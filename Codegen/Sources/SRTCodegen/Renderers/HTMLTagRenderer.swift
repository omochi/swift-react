import Foundation
import CodegenKit

struct HTMLTagRenderer: Renderer {
    var def: Def

    func isTarget(file: URL) -> Bool {
        file.lastPathComponent == "HTMLTags.swift"
    }
    
    func render(template: inout CodeTemplateModule.CodeTemplate, file: URL, on runner: CodegenKit.CodegenRunner) throws {
        let code = def.tagNames.map { (tag) in
            renderTagFunc(tag: tag)
        }.joined(separator: "\n")

        template["tags"] = code
    }
    
    private func renderTagFunc(tag: String) -> String {
        """
        public func \(renderIdentifier(tag))(
            key: AnyHashable? = nil,
            ref: RefObject<JSHTMLElement>? = nil,
            attributes: Attributes? = nil,
            style: Style? = nil,
            listeners: EventListeners? = nil,
            @ChildrenBuilder _ children: () -> [Node] = { [] }
        ) -> HTMLElement {
            HTMLElement(
                tagName: "\(tag)",
                key: key,
                ref: ref,
                attributes: attributes,
                style: style,
                listeners: listeners,
                children: children()
            )
        }

        """
    }
}
