// Copyright 2020 Carton contributors
//
// Licensed under the Apache License, Version 2.0 (the "License");
// you may not use this file except in compliance with the License.
// You may obtain a copy of the License at
//
//     http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing, software
// distributed under the License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
// See the License for the specific language governing permissions and
// limitations under the License.

import { WASI } from "@wasmer/wasi";
import { WasmFs } from "@wasmer/wasmfs";
import * as path from "path-browserify";
import { SwiftRuntime as JavaScriptKitRuntime } from "../JavaScriptKit/Runtime/src/index";

export type Options = {
  args?: string[];
  onStdout?: (text: string) => void;
  onStderr?: (text: string) => void;
};

export type WasmRunner = {
  run(wasmBytes: ArrayBufferLike, extraWasmImports?: WebAssembly.Imports): Promise<void>
};

export const WasmRunner = (rawOptions: Options | false, SwiftRuntime: typeof JavaScriptKitRuntime): WasmRunner => {
  const options: Options = defaultRunnerOptions(rawOptions);

  let swift: JavaScriptKitRuntime;
  if (SwiftRuntime) {
    swift = new SwiftRuntime();
  }

  const wasmFs = createWasmFS(
    (stdout) => {
      console.log(stdout);
      options.onStdout?.call(undefined, stdout);
    },
    (stderr) => {
      console.error(stderr);
      options.onStderr?.call(undefined, stderr);
    }
  );

  wasmFs.fs.mkdirSync("/sandbox");

  const wasi = new WASI({
    args: options.args,
    env: {},
    preopenDirectories: {
      "/": "/sandbox",
    },
    bindings: {
      ...WASI.defaultBindings,
      fs: wasmFs.fs,
      path: path,
    },
  });

  const createWasmImportObject = (
    extraWasmImports: WebAssembly.Imports, 
    wasmModule: WebAssembly.Module
  ): WebAssembly.Imports => {
    const importObject: WebAssembly.Imports = {
      wasi_snapshot_preview1: wrapWASI(wasi, wasmModule),
    };

    if (swift) {
      importObject.javascript_kit = swift.wasmImports as unknown as WebAssembly.ModuleImports;
    }

    if (extraWasmImports) {
      // Shallow clone
      for (const key in extraWasmImports) {
        importObject[key] = extraWasmImports[key];
      }
    }

    return importObject;
  };

  return {
    async run(wasmBytes: ArrayBufferLike, extraWasmImports?: WebAssembly.Imports) {
      if (!extraWasmImports) {
        extraWasmImports = {};
      }
      extraWasmImports.__stack_sanitizer = {
        report_stack_overflow: () => {
          throw new Error("Detected stack buffer overflow.");
        },
      };
      const module = await WebAssembly.compile(wasmBytes);
      const importObject = createWasmImportObject(extraWasmImports, module);
      const instance = await WebAssembly.instantiate(module, importObject);

      if (swift && instance.exports.swjs_library_version) {
        swift.setInstance(instance);
      }

      // Start the WebAssembly WASI instance
      wasi.start(instance);

      // Initialize and start Reactor
      if (typeof instance.exports._initialize == "function") {
        instance.exports._initialize();
        if (typeof instance.exports.main === "function") {
          instance.exports.main();
        } else if (typeof instance.exports.__main_argc_argv === "function") {
          // Swift 6.0 and later use `__main_argc_argv` instead of `main`.
          instance.exports.__main_argc_argv(0, 0);
        }
      }
    },
  };
};

const defaultRunnerOptions = (options: Options | false): Options => {
  if (!options) return defaultRunnerOptions({});
  if (!options.onStdout) {
    options.onStdout = () => { };
  }
  if (!options.onStderr) {
    options.onStderr = () => { };
  }
  if (!options.args) {
    options.args = ["main.wasm"];
  }
  return options;
};

const createWasmFS = (
    onStdout: (text: string) => void, 
    onStderr: (text: string) => void
): WasmFs => {
  // Instantiate a new WASI Instance
  const wasmFs = new WasmFs();

  // Output stdout and stderr to console
  const originalWriteSync = wasmFs.fs.writeSync;
  (wasmFs.fs as any).writeSync = (
    fd: number, 
    buffer: Buffer | Uint8Array, 
    offset?: number, 
    length?: number, 
    position?: number
  ): number => {
    const text = new TextDecoder("utf-8").decode(buffer);
    if (text !== "\n") {
      switch (fd) {
        case 1:
          onStdout(text);
          break;
        case 2:
          onStderr(text);
          break;
      }
    }
    return originalWriteSync(fd, buffer, offset, length, position);
  };

  return wasmFs;
};

const wrapWASI = (wasiObject: WASI, wasmModule: WebAssembly.Module): WebAssembly.ModuleImports => {
  // PATCH: @wasmer-js/wasi@0.x forgets to call `refreshMemory` in `clock_res_get`,
  // which writes its result to memory view. Without the refresh the memory view,
  // it accesses a detached array buffer if the memory is grown by malloc.
  // But they wasmer team discarded the 0.x codebase at all and replaced it with
  // a new implementation written in Rust. The new version 1.x is really unstable
  // and not production-ready as far as katei investigated in Apr 2022.
  // So override the broken implementation of `clock_res_get` here instead of
  // fixing the wasi polyfill.
  // Reference: https://github.com/wasmerio/wasmer-js/blob/55fa8c17c56348c312a8bd23c69054b1aa633891/packages/wasi/src/index.ts#L557
  const original_clock_res_get = wasiObject.wasiImport["clock_res_get"];

  wasiObject.wasiImport["clock_res_get"] = (clockId: number, resolution: number) => {
    wasiObject.refreshMemory();
    return original_clock_res_get(clockId, resolution);
  };

  // @wasmer-js/wasi polyfill does not support all WASI syscalls like `sock_accept`.
  // So we need to insert a dummy function for unimplemented syscalls.
  const __WASI_ERRNO_NOTSUP = 58;
  for (const importEntry of WebAssembly.Module.imports(wasmModule)) {
    const { module: importModule, name: importName, kind: importKind } = importEntry;
    // Skip dummy import entries for non-WASI and already implemented syscalls.
    if (
      importModule !== "wasi_snapshot_preview1" ||
      importKind !== "function" ||
      wasiObject.wasiImport[importName]
    ) {
      continue;
    }

    wasiObject.wasiImport[importName] = () => {
      console.warn(`WASI syscall ${importModule}.${importName} is not supported, returning ENOTSUP.`);
      return __WASI_ERRNO_NOTSUP;
    }
  }

  return wasiObject.wasiImport;
};
