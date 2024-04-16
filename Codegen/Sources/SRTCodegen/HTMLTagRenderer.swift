import Foundation
import CodegenKit

struct HTMLTagRenderer: Renderer {
    var tags: [String]
    
    func isTarget(file: URL) -> Bool {
        file.lastPathComponent == "HTMLTags.swift"
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
            attributes: Attributes = [:],
            listeners: EventListeners = [:],
            @ChildrenBuilder _ children: () -> [Node] = { [] }
        ) -> HTMLElement {
            HTMLElement(
                tagName: "\(tag)",
                key: key,
                ref: ref,
                attributes: attributes,
                listeners: listeners,
                children: children()
            )
        }

        """
    }
}
