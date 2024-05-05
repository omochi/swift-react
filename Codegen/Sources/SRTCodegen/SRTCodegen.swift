import Foundation
import CodegenKit

public struct SRTCodegen {
    public init() throws {
        self.codegenDir = URL(filePath: ".", directoryHint: .isDirectory)
        self.swiftReactDir = codegenDir.deletingLastPathComponent()
        self.htmlSourceDir = swiftReactDir.appending(components: "Sources", "React", "HTML", directoryHint: .isDirectory)
        let json = try Data(contentsOf: codegenDir.appending(path: "data.json"))
        let decoder = JSONDecoder()
        self.def = try decoder.decode(Def.self, from: json)
        def.fix()
    }

    var codegenDir: URL
    var swiftReactDir: URL
    var htmlSourceDir: URL
    var def: Def

    public func run() throws {
        let runner = CodegenRunner(
            renderers: [
                HTMLTagRenderer(def: def),
                HTMLVoidTagRenderer(def: def),
                AttributeRenderer(def: def),
                StyleRenderer(def: def)
            ]
        )

        try runner.run(directories: [htmlSourceDir])
    }
}
