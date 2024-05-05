import Foundation
import CodegenKit

struct EventListenersRenderer: Renderer {
    var def: Def

    func isTarget(file: URL) -> Bool {
        file.lastPathComponent == "EventListeners.swift"
    }

    func render(template: inout CodeTemplateModule.CodeTemplate, file: URL, on runner: CodegenKit.CodegenRunner) throws {
        let code = def.eventAttributes.map { (attribute) in
            renderSetter(attribute: attribute)
        }.joined(separator: "\n")

        template["setters"] = code
    }

    private func renderSetter(attribute: String) -> String {
        var attribute = attribute
        if attribute.hasPrefix("on") {
            attribute.removeFirst(2)
        }

        return """
        public func \(renderIdentifier(attribute))(_ value: EventListener) -> EventListeners {
            set("\(attribute)", to: value)
        }

        """
    }
}
