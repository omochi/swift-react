import SRTCore
import DOMModule
package import VDOMModule

public final class ReactRoot {
    public init(
        element: DOMTagNode
    ) {
        self.dom = element
        self.root = VNode.component(Fragment())
    }

    public let dom: DOMTagNode
    package var root: VNode

    public func render(node: Node) {
        /*
         TODO: implement render cycle
         */

        do {
            let newRoot = VNode.component(Fragment())
            let newTree = try renderVTree(node: node)
            newRoot.appendChildren(newTree)
            try update(newTree: newTree, oldTree: root.children)
            self.root = newRoot
        } catch {
            print(error)
        }
    }

    private func flatten(node: Node) throws -> [any Component] {
        guard let node else { return [] }

        switch node {
        case let node as NodeCollection:
            return try node.children.flatMap { (node) in
                try flatten(node: node)
            }
        default:
            return [node]
        }
    }

    private func renderComponent<C: Component>(_ component: C) throws -> VNode {
        let ghost = C._extractGhost(
            .init(component: component)
        )
        let v = VNode(ghost: ghost)

        let child = component.render()
        for vc in try renderVTree(node: child) {
            v.appendChild(vc)
        }
        return v
    }

    private func renderVTree(
        node: Node
    ) throws -> [VNode] {
        let components = try flatten(node: node)
        return try components.map { (component) in
            try renderComponent(component)
        }
    }

    private func unknownReactNode(_ node: Node) -> any Error {
        MessageError("unknown ReactNode: \(type(of: node))")
    }

    private func update(
        newTree: [VNode],
        oldTree: [VNode]
    ) throws {
        var patchedOldTree: [VNode?] = oldTree

        let diff = newTree.difference(from: oldTree)
            .inferringMoves()

        var nextIndex = 0

        for patch in diff {
            switch patch {
            case .remove(offset: let offset, element: let oldNode, associatedWith: let dest):
                patchedOldTree.remove(at: offset)

                if let _ = dest {
                    // process on insert
                } else {
                    try destroyInstance(node: oldNode)
                }
            case .insert(offset: let offset, element: let newNode, associatedWith: let source):
                for index in nextIndex..<offset {
                    let newNode = newTree[index]
                    let oldNode = try patchedOldTree[index].unwrap("updating oldNode")
                    try updateInstance(newNode: newNode, oldNode: oldNode)
                }
                nextIndex = offset + 1

                patchedOldTree.insert(nil, at: offset)

                if let source {
                    let oldNode = oldTree[source]
                    try updateInstance(newNode: newNode, oldNode: oldNode)
                } else {
                    try createInstance(node: newNode)
                }
            }
        }

        for index in nextIndex..<newTree.count {
            let newNode = newTree[index]
            let oldNode = try patchedOldTree[index].unwrap("updating oldNode")
            try updateInstance(newNode: newNode, oldNode: oldNode)
        }
        nextIndex = newTree.count
    }

    private func createInstance(node: VNode) throws {
        if let tag = node.tagElement {
//            print("create \(tag.tagName)")
            let dom = DOMTagNode(tagName: tag.tagName)
            dom.strings = tag.strings
            dom.eventHandlers = tag.eventHandlers
            node.dom = dom
            try attachDOM(node: node)
        }

        try update(newTree: node.children, oldTree: [])
    }

    private func attachDOM(node: VNode) throws {
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
        try update(newTree: [], oldTree: node.children)
        node.dom?.removeFromParent()
    }

    private func updateInstance(newNode: VNode, oldNode: VNode) throws {
        if let tag = newNode.tagElement {
            let dom = try oldNode.dom.unwrap("oldNode.dom")
            dom.strings = tag.strings
            dom.eventHandlers = tag.eventHandlers
            newNode.dom = dom

            let newLocation = try domLocation(node: newNode)
            if newLocation != dom.location {
                dom.removeFromParent()
                attachDOM(dom, at: newLocation)
            }
        }

        try update(newTree: newNode.children, oldTree: oldNode.children)
    }
}
