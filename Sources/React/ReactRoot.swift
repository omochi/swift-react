import SRTCore
import SRTDOM
import JavaScriptKitShim
package import VDOMModule

public final class ReactRoot {
    public init(
        element: JSHTMLElement
    ) {
        self.dom = element
        self.root = VNode.component(Fragment())

        self.window = JSWindow.global
        self.document = window.document
    }

    public let dom: JSHTMLElement
    package var root: VNode

    private let window: JSWindow
    private let document: JSDocument

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

    private func normalize(node: Node) throws -> [any Component] {
        guard let node else { return [] }

        switch node {
        case let nodes as NodeCollection:
            return try nodes.children.flatMap { (node) in
                try normalize(node: node)
            }
        case let text as String:
            return [TextElement(text)]
        case let component as any Component:
            return [component]
        default:
            throw unknownReactNode(node)
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
        let components = try normalize(node: node)
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

    private func attachDOM(node: VNode) throws {
        let dom = try node.dom.unwrap("dom")
        guard dom.parentNode == nil else {
            throw MessageError("dom already attached")
        }
        let location = try self.domNodeLocation(node: node)
        dom.insert(at: location)
    }

    private func domNodeLocation(node: VNode) throws -> JSNodeLocation {
        let parent = try parentDOM(node: node)
        let prev = try prevSiblingDOM(node: node)
        return JSNodeLocation(parent: parent, next: prev?.nextSibling)
    }

    private func parentDOM(node: VNode) throws -> JSNode {
        guard let parent = node.parentTagNode else {
            return dom
        }
        return try parent.domTag.unwrap("domTag")
    }

    private func prevSiblingDOM(node: VNode) throws -> JSNode? {
        guard let prev = try node.prevSiblingTagNode else {
            return nil
        }
        return try prev.dom.unwrap("dom")
    }

    private func destroyInstance(node: VNode) throws {
        try update(newTree: [], oldTree: node.children)
        node.dom?.remove()
    }

    private func createInstance(node: VNode) throws {
        if let tag = node.tagElement {
            let dom = document.createElement(tag.tagName)
            // TODO
//            dom.strings = tag.strings
//            dom.eventHandlers = tag.eventHandlers
            node.dom = dom
            try attachDOM(node: node)
        } else if let text = node.textElement {
            let dom = document.createTextNode(text.value)
            node.dom = dom
            try attachDOM(node: node)
        }

        try update(newTree: node.children, oldTree: [])
    }

    private func updateInstance(newNode: VNode, oldNode: VNode) throws {
        if let tag = newNode.tagElement {
            let dom = try oldNode.domTag.unwrap("oldNode.domTag")
            // TODO
//            dom.strings = tag.strings
//            dom.eventHandlers = tag.eventHandlers
            newNode.dom = dom
        } else if let text = newNode.textElement {
            let dom = try oldNode.domText.unwrap("oldNode.domText")
            dom.data = text.value
            newNode.dom = dom
        }

        if let dom = newNode.dom {
            let location = try domNodeLocation(node: newNode)
            if location != dom.location {
                dom.remove()
                dom.insert(at: location)
            }
        }

        try update(newTree: newNode.children, oldTree: oldNode.children)
    }
}
