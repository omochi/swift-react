import Foundation
import CodegenKit

public struct SRTCodegen {
    public init() throws {
        self.codegenDir = URL(filePath: ".", directoryHint: .isDirectory)
        self.swiftReactDir = codegenDir.deletingLastPathComponent()
        self.htmlSourceDir = swiftReactDir.appending(components: "Sources", "React", "HTML", directoryHint: .isDirectory)
        let tagsDir = codegenDir.appending(components: "node_modules", "html-tags")
        let tagsJSON = try Data(contentsOf: tagsDir.appending(path: "html-tags.json"))
        let decoder = JSONDecoder()
        self.tags = try decoder.decode(Array<String>.self, from: tagsJSON)
        let leafJSON = try Data(contentsOf: tagsDir.appending(path: "html-tags-void.json"))
        self.leafTags = try decoder.decode(Array<String>.self, from: leafJSON)
    }

    var codegenDir: URL
    var swiftReactDir: URL
    var htmlSourceDir: URL
    var tags: [String]
    var leafTags: [String]

    public func run() throws {
        let runner = CodegenRunner(
            renderers: [
                HTMLTagRenderer(tags: tags),
                HTMLLeafTagRenderer(tags: leafTags)
            ]
        )

        try runner.run(directories: [htmlSourceDir])
    }
}
