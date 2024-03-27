import SRTCore
@_exported import ReactInterface
import DOMModule
package import VDOMModule

public final class Root {
    public init(
        element: DOMNode
    ) {
        self.dom = element
    }

    public let dom: DOMNode
    private var tree: VNode?

    public func render(node: (any ReactNode)?) {
        /*
         TODO: implement render cycle
         */

        do {
            let newTree = try buildVTree(node: node)
            try render(newTree: newTree, oldTree: tree, parentDOM: dom)
        } catch {
            print(error)
        }
    }

    private func buildVTree(
        node: (any ReactNode)?
    ) throws -> VNode? {
        guard let node else {
            return nil
        }

        switch node {
        case let node as TagElement:
            let v = VTagNode(
                tagName: node.tagName,
                attributes: node.attributes
            )
            for nc in node.children {
                if let vc = try buildVTree(node: nc) {
                    v.appendChild(vc)
                }
            }
            return v
        case let component as ReactComponent:
            let v = VComponentNode(
                component: component
            )
            if let node = component.render(),
               let vc = try buildVTree(node: node)
            {
                v.appendChild(vc)
            }
            return v
        default:
            throw MessageError("unknown node: \(type(of: node))")
        }
    }

    private func render(newTree: VNode?, oldTree: VNode?, parentDOM: DOMNode) {

    }
}
