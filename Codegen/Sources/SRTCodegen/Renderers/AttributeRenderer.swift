import Foundation
import CodegenKit

struct AttributeRenderer: Renderer {
    var def: Def

    func isTarget(file: URL) -> Bool {
        file.lastPathComponent == "Attributes.swift"
    }

    func render(template: inout CodeTemplateModule.CodeTemplate, file: URL, on runner: CodegenKit.CodegenRunner) throws {
        let code = def.allAttributes.map { (attribute) in
            renderSetter(attribute: attribute)
        }.joined(separator: "\n")

        template["setters"] = code
    }

    private func renderSetter(attribute: String) -> String {
        let symbol = attribute.kebabToCamel()

        return """
        public func \(renderIdentifier(symbol))(_ x: String) -> Attributes {
            set("\(attribute)", to: x)
        }

        """
    }
}
