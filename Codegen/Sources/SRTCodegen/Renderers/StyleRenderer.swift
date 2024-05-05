import Foundation
import CodegenKit

struct StyleRenderer: Renderer {
    var def: Def

    func isTarget(file: URL) -> Bool {
        file.lastPathComponent == "Style.swift"
    }

    func render(template: inout CodeTemplateModule.CodeTemplate, file: URL, on runner: CodegenKit.CodegenRunner) throws {
        let code = def.cssProperties.map { (attribute) in
            renderSetter(attribute: attribute)
        }.joined(separator: "\n")

        template["setters"] = code
    }

    private func renderSetter(attribute: String) -> String {
        let symbol = attribute.kebabToCamel()

        return """
        public func \(renderIdentifier(symbol))(_ value: String) -> Style {
            set("\(attribute)", to: value)
        }

        """
    }
}
