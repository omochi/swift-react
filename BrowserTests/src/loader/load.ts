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

import { WasmRunner } from "./WasmRunner";
import { SwiftRuntime } from "../JavaScriptKit/Runtime/src/index";

const startWasiTask = async (exePath: string) => {
  // Fetch our Wasm File
  const response = await fetch(exePath);
  const responseArrayBuffer = await response.arrayBuffer();

  const wasmRunner = WasmRunner(false, SwiftRuntime);

  // Instantiate the WebAssembly file
  const wasmBytes = new Uint8Array(responseArrayBuffer).buffer;
  await wasmRunner.run(wasmBytes);
};

function handleError(e: any) {
  console.error(e);
  if (e.stack != null) {
    console.log(e.stack);
  }
}

export function load(exePath: string) {
  try {
    startWasiTask(exePath).catch(handleError);
  } catch (e) {
    handleError(e);
  }
}
