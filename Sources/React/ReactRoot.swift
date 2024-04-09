import SRTCore
import SRTDOM
import SRTJavaScriptKitEx
package import VDOMModule

public final class ReactRoot {
    public init(
        element: JSHTMLElement
    ) {
        self.dom = element
        self.root = nil

        self.window = JSWindow.global
        self.document = window.document
    }

    public let dom: JSHTMLElement
    package var root: VNode?

    private let window: JSWindow
    private let document: JSDocument

    public func render(node: Node) {
        /*
         TODO: implement render cycle
         */

        do {
            let newTree = makeVNode(component: Fragment())
            let newChildren = try normalize(node: node)
                .map { makeVNode(component: $0) }
            newTree.appendChildren(newChildren)
            try render(newChildren: newChildren, oldChildren: root?.children ?? [])
            self.root = newTree
        } catch {
            print(error)
        }
    }

    private func makeVNode<C: Component>(component: C) -> VNode {
        let ghost = C._extractGhost(
            .init(component: component)
        )
        return VNode(ghost: ghost)
    }

    private func render(
        newTree: VNode?,
        oldTree: VNode?
    ) throws {
        var doesRenderChildren = true

        if let newTree {
            if let newTag = newTree.tagElement {
                let dom: JSHTMLElement = if let oldTree {
                    try oldTree.domTag.unwrap("oldTree.domTag")
                } else {
                    try document.createElement(newTag.tagName)
                }

                let oldTag = oldTree?.tagElement
                newTree.dom = dom.asNode()
                newTree.listeners = oldTree?.listeners ?? [:]
                newTag.ref?.value = dom

                try renderDOMAttributes(
                    dom: dom,
                    newAttributes: newTag.attributes,
                    oldAttributes: oldTag?.attributes ?? [:]
                )
                try renderDOMEventListeners(
                    node: newTree,
                    dom: dom,
                    newListeners: newTag.listeners,
                    oldListeners: oldTag?.listeners ?? [:]
                )
            } else if let text = newTree.textElement {
                let dom: JSText = try {
                    if let oldTree {
                        let dom = try oldTree.domText.unwrap("oldTree.domText")
                        dom.data = text.value
                        return dom
                    } else {
                        return try document.createTextNode(text.value)
                    }
                }()

                newTree.dom = dom.asNode()
            }

            if let dom = newTree.dom {
                let location = try domNodeLocation(node: newTree)
                if location != dom.location {
                    try dom.remove()
                    try dom.insert(at: location)
                }
            }

            renderGhost(newTree: newTree, oldTree: oldTree)

            let isSameDeps: Bool = if let newDeps = newTree.ghost.component.deps,
                newDeps == oldTree?.ghost.component.deps
            {
                true
            } else { false }

            // TODO: check dirty flag

            if isSameDeps {
                doesRenderChildren = false

            }

            if doesRenderChildren {
                let newChildrenNode: Node = newTree.ghost.component.render()
                let newChildren = try normalize(node: newChildrenNode).map {
                    makeVNode(component: $0)
                }
                newTree.appendChildren(newChildren)
            } else {
                newTree.appendChildren(oldTree?.children ?? [])
            }
        }

        if doesRenderChildren {
            try render(
                newChildren: newTree?.children ?? [],
                oldChildren: oldTree?.children ?? []
            )
        }

        if newTree == nil {
            if let oldTree {
                try oldTree.dom?.remove()
            }
        }
    }

    private func renderGhost(newTree: VNode, oldTree: VNode?) {
        for (name, oldRef) in oldTree?.ghost.refs ?? [:] {
            if let newRef = newTree.ghost.refs[name] {
                newRef._anyValue = oldRef._anyValue
            }
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

    private func unknownReactNode(_ node: Node) -> any Error {
        MessageError("unknown ReactNode: \(type(of: node))")
    }

    private func render(
        newChildren: [VNode],
        oldChildren: [VNode]
    ) throws {
        var patchedOldChildren: [VNode?] = oldChildren

        let diff = newChildren.difference(from: oldChildren)
            .inferringMoves()

        var nextIndex = 0

        for patch in diff {
            switch patch {
            case .remove(offset: let offset, element: let oldNode, associatedWith: let dest):
                patchedOldChildren.remove(at: offset)

                if let _ = dest {
                    // process on insert
                } else {
                    try render(newTree: nil, oldTree: oldNode)
                }
            case .insert(offset: let offset, element: let newNode, associatedWith: let source):
                for index in nextIndex..<offset {
                    let newNode = newChildren[index]
                    let oldNode = try patchedOldChildren[index].unwrap("updating oldNode")
                    try render(newTree: newNode, oldTree: oldNode)
                }
                nextIndex = offset + 1

                patchedOldChildren.insert(nil, at: offset)

                let oldNode = source.map { oldChildren[$0] }
                try render(newTree: newNode, oldTree: oldNode)
            }
        }

        for index in nextIndex..<newChildren.count {
            let newNode = newChildren[index]
            let oldNode = try patchedOldChildren[index].unwrap("updating oldNode")
            try render(newTree: newNode, oldTree: oldNode)
        }
        nextIndex = newChildren.count
    }

    private func attachDOM(node: VNode) throws {
        let dom = try node.dom.unwrap("dom")
        guard dom.parentNode == nil else {
            throw MessageError("dom already attached")
        }
        let location = try self.domNodeLocation(node: node)
        try dom.insert(at: location)
    }

    private func domNodeLocation(node: VNode) throws -> JSNodeLocation {
        let parent = try parentDOM(node: node)
        let prev = try prevSiblingDOM(node: node)

        var next: JSNode? = if let prev {
            prev.nextSibling
        } else {
            parent.firstChild
        }

        if let n = next, n == node.dom {
            next = n.nextSibling
        }

        return JSNodeLocation(
            parent: parent.asNode(),
            next: next
        )
    }

    private func parentDOM(node: VNode) throws -> JSHTMLElement {
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

    private func renderDOMAttributes(
        dom: JSHTMLElement,
        newAttributes: Attributes,
        oldAttributes: Attributes
    ) throws {
        for name in oldAttributes.keys {
            if newAttributes[name] == nil {
                try dom.removeAttribute(name)
            }
        }

        for (name, newValue) in newAttributes {
            if newValue != oldAttributes[name] {
                try dom.setAttribute(name, newValue)
            }
        }
    }

    private func renderDOMEventListeners(
        node: VNode,
        dom: JSHTMLElement,
        newListeners: EventListeners,
        oldListeners: EventListeners
    ) throws {
        for (type, oldListener) in oldListeners {
            if oldListener != newListeners[type] {
                if let bridge = node.listeners[type] {
                    if let js = bridge.js {
                        try dom.removeEventListener(type, js)
                    }
                    node.listeners[type] = nil
                }
            }
        }

        for (type, newListener) in newListeners {
            if newListener != oldListeners[type] {
                if let bridge = node.listeners[type] {
                    bridge.swift = newListener
                } else {
                    let bridge = VNode.ListenerBridge()
                    node.listeners[type] = bridge

                    let js = JSEventListener { [weak bridge] (event) in
                        guard let bridge, let swift = bridge.swift else { return }
                        swift(event)
                    }

                    bridge.js = js
                    bridge.swift = newListener

                    try dom.addEventListener(type, js)
                }
            }
        }
    }
}
