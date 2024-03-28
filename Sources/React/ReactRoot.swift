import SRTCore
@_exported import ReactInterface
import DOMModule
package import VDOMModule

public final class ReactRoot {
    public init(
        element: DOMTagNode
    ) {
        self.dom = element
        self.tree = nil
    }

    public let dom: DOMTagNode
    package var tree: VNode?

    public func render(node: (any ReactNode)?) {
        /*
         TODO: implement render cycle
         */

        do {
            let newTree = try buildVTree(node: node)
            try render(newTree: newTree, oldTree: tree, oldTreeParent: nil)
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
            throw unknownReactNode(node)
        }
    }

    private func unknownReactNode(_ node: any ReactNode) -> any Error {
        MessageError("unknown ReactNode: \(type(of: node))")
    }

    private func render(
        newTree: VNode?,
        oldTree: VNode?,
        oldTreeParent: VNode?
    ) throws {
        guard let newTree else {
            if let oldTree {
                try destroyInstance(node: oldTree)
                return
            }

            return
        }

        switch newTree {
        case let newTree as VTagNode:
            if let oldTree = oldTree as? VTagNode {
                // TODO: update
            } else {
                if let oldTree {
                    try destroyInstance(node: oldTree)
                }
            }

            try createInstance(node: newTree)
        case let newTree as VComponentNode:
            if let oldTree = oldTree as? VComponentNode {
                // TODO: update
            } else {
                if let oldTree {
                    try destroyInstance(node: oldTree)
                }
            }

            try createInstance(node: newTree)
        default:
            throw VNode.unknownNode(newTree)
        }
    }

    private func createInstance(node: VNode) throws {
        switch node {
        case let node as VTagNode:
            let dom = DOMTagNode(
                tagName: node.tagName,
                attributes: node.attributes
            )
            node.dom = dom
            try appendDOM(node: node, dom: dom)
            
            for x in node.children {
                try createInstance(node: x)
            }
        case let node as VComponentNode:
            for x in node.children {
                try createInstance(node: x)
            }
        default:
            throw VNode.unknownNode(node)
        }
    }

    private func appendDOM(node: VNode, dom: DOMTagNode) throws {
        let parent = try parentDOM(node: node)
        let index = if let prev = try prevSiblingDOM(node: node) {
            (
                try parent.children.firstIndex(where: { $0 === prev })
                    .unwrap("prev dom index")
            ) + 1
        } else {
            0
        }
        parent.insertChild(dom, at: index)
    }

    private func parentDOM(node: VNode) throws -> DOMTagNode {
        guard let parent = node.parentTagNode else {
            return dom
        }
        return try parent.dom.unwrap("dom")
    }

    private func prevSiblingDOM(node: VNode) throws -> DOMTagNode? {
        guard let prev = try node.prevSiblingTagNode else {
            return nil
        }
        return try prev.dom.unwrap("dom")
    }

    private func destroyInstance(node: VNode) throws {
        switch node {
        case let node as VTagNode:
            for x in node.children {
                try destroyInstance(node: x)
            }
            if let dom = node.dom {
                dom.removeFromParent()
            }
        case let node as VComponentNode:
            for x in node.children {
                try destroyInstance(node: x)
            }
        default:
            throw VNode.unknownNode(node)
        }
    }
}
