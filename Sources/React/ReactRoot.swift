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

    public func render(node: ReactNode) {
        /*
         TODO: implement render cycle
         */

        do {
            let newTree = try renderVTree(node: node)
            try update(newTree: newTree, oldTree: tree)
            self.tree = newTree
        } catch {
            print(error)
        }
    }

    private func renderVTree(
        node: ReactNode
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
                if let vc = try renderVTree(node: nc) {
                    v.appendChild(vc)
                }
            }
            return v
        case let component as any ReactComponent:
            let v = VComponentNode(
                component: component
            )
            if let node = component.render(),
               let vc = try renderVTree(node: node)
            {
                v.appendChild(vc)
            }
            return v
        default:
            throw unknownReactNode(node)
        }
    }

    private func unknownReactNode(_ node: ReactNode) -> any Error {
        MessageError("unknown ReactNode: \(type(of: node))")
    }

    private func update(
        newTree: VNode?,
        oldTree: VNode?
    ) throws {
        guard let newTree else {
            if let oldTree {
                try destroyInstance(node: oldTree)
            }
            return
        }

        if let oldTree, newTree.isEqual(to: oldTree) {
            try updateInstance(newNode: newTree, oldNode: oldTree)
            return
        }

        switch newTree {
        case let newTree as VTagNode:
            if let oldTree {
                try destroyInstance(node: oldTree)
            }
            try createInstance(node: newTree)
        case let newTree as VComponentNode:
            if let oldTree {
                try destroyInstance(node: oldTree)
            }
            try createInstance(node: newTree)
        default:
            throw VNode.unknownNode(newTree)
        }
    }

    private struct ChildDiffAdapter: Equatable & Hashable {
        var node: VNode
        var token: VNode.EQToken

        init(node: VNode) {
            self.node = node
            self.token = node.eqToken
        }

        static func ==(a: Self, b: Self) -> Bool { a.token == b.token }
        func hash(into hasher: inout Hasher) { hasher.combine(token) }
    }

    private func updateChildren(
        newTree: VParentNode,
        oldTree: VParentNode
    ) throws {
        let newChildren = newTree.children.map(ChildDiffAdapter.init)
        let oldChildren = oldTree.children.map(ChildDiffAdapter.init)
        var patchedChildren: [VNode?] = oldChildren.map { $0.node }

        let diff = newChildren.difference(from: oldChildren)
            .inferringMoves()

        var nextIndex = 0

        for patch in diff {
            switch patch {
            case .remove(offset: let offset, element: let oldNode, associatedWith: let dest):
                patchedChildren.remove(at: offset)

                if let _ = dest {
                    // process on insert
                } else {
                    try destroyInstance(node: oldNode.node)
                }
            case .insert(offset: let offset, element: let newNode, associatedWith: let source):
                for index in nextIndex..<offset {
                    let newNode = newChildren[index].node
                    let oldNode = try patchedChildren[index].unwrap("updating oldNode")
                    try updateInstance(newNode: newNode, oldNode: oldNode)
                }
                nextIndex = offset + 1

                patchedChildren.insert(nil, at: offset)

                if let source {
                    let oldNode = oldChildren[source].node
                    try updateInstance(newNode: newNode.node, oldNode: oldNode)
                } else {
                    try createInstance(node: newNode.node)
                }
                break
            }
        }

        for index in nextIndex..<newChildren.count {
            let newNode = newChildren[index].node
            let oldNode = try patchedChildren[index].unwrap("updating oldNode")
            try updateInstance(newNode: newNode, oldNode: oldNode)
        }
        nextIndex = newChildren.count
    }

    private func createInstance(node: VNode) throws {
        switch node {
        case let node as VTagNode:
            let dom = DOMTagNode(
                tagName: node.tagName,
                attributes: node.attributes
            )
            node.dom = dom
            try attachDOM(node: node)

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

    private func attachDOM(node: VTagNode) throws {
        let dom = try node.dom.unwrap("dom")
        guard dom.parent == nil else {
            throw MessageError("dom already attached")
        }
        let location = try self.domLocation(node: node)
        self.attachDOM(dom, at: location)
    }

    private func attachDOM(_ dom: DOMNode, at location: DOMLocation) {
        location.parent.insertChild(dom, at: location.index)
    }

    private func domLocation(node: VNode) throws -> DOMLocation {
        let parent = try parentDOM(node: node)
        let index = if let prev = try prevSiblingDOM(node: node) {
            try parent.index(of: prev).unwrap("prev dom index") + 1
        } else { 0 }
        return DOMLocation(parent: parent, index: index)
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

    private func updateInstance(newNode: VNode, oldNode: VNode) throws {
        switch newNode {
        case let newNode as VTagNode:
            let oldNode = try (oldNode as? VTagNode).unwrap("oldNode as VTagNode")
            let dom = try oldNode.dom.unwrap("oldNode.dom")
            dom.attributes = newNode.attributes
            newNode.dom = dom

            let newLocation = try domLocation(node: newNode)
            if newLocation != dom.location {
                dom.removeFromParent()
                attachDOM(dom, at: newLocation)
            }

            try updateChildren(newTree: newNode, oldTree: oldNode)
        case let newNode as VComponentNode:
            let oldNode = try (oldNode as? VComponentNode).unwrap("oldNode as VComponentNode")
            try updateChildren(newTree: newNode, oldTree: oldNode)
        default:
            throw VNode.unknownNode(newNode)
        }
    }
}
