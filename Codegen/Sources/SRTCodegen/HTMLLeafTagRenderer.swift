import Foundation
import CodegenKit

struct HTMLLeafTagRenderer: Renderer {
    var tags: [String]

    func isTarget(file: URL) -> Bool {
        file.lastPathComponent == "HTMLLeafTags.swift"
    }

    func render(template: inout CodeTemplateModule.CodeTemplate, file: URL, on runner: CodegenKit.CodegenRunner) throws {
        let code = tags.map { (tag) in
            renderTagFunc(tag: tag)
        }.joined(separator: "\n")

        template["tags"] = code
    }

    private func renderTagFunc(tag: String) -> String {
        """
        public func \(tag)(
            key: AnyHashable? = nil,
            ref: RefObject<JSHTMLElement>? = nil,
            attributes: Attributes? = nil,
            style: Style? = nil,
            listeners: EventListeners? = nil
        ) -> HTMLElement {
            HTMLElement(
                tagName: "\(tag)",
                key: key,
                ref: ref,
                attributes: attributes,
                style: style,
                listeners: listeners
            )
        }

        """
    }
}
