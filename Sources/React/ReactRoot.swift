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
                    try updateInstance(newNode: nil, oldNode: oldNode)
                }
            case .insert(offset: let offset, element: let newNode, associatedWith: let source):
                for index in nextIndex..<offset {
                    let newNode = newTree[index]
                    let oldNode = try patchedOldTree[index].unwrap("updating oldNode")
                    try updateInstance(newNode: newNode, oldNode: oldNode)
                }
                nextIndex = offset + 1

                patchedOldTree.insert(nil, at: offset)

                let oldNode = source.map { oldTree[$0] }
                try updateInstance(newNode: newNode, oldNode: oldNode)
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
        try dom.insert(at: location)
    }

    private func domNodeLocation(node: VNode) throws -> JSNodeLocation {
        let parent = try parentDOM(node: node)
        let prev = try prevSiblingDOM(node: node)

        var next: JSNode? = if let prev {
            prev.nextSibling
        } else {
            parent.asNode().firstChild
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

    private func updateInstance(newNode: VNode?, oldNode: VNode?) throws {
        if let newNode {
            if let newTag = newNode.tagElement {
                let dom: JSHTMLElement = if let oldNode {
                    try oldNode.domTag.unwrap("oldNode.domTag")
                } else {
                    try document.createElement(newTag.tagName)
                }

                let oldTag = try oldNode?.tagElement.unwrap("oldNode.tagElement")
                try renderDOMAttributes(
                    dom: dom,
                    newAttributes: newTag.attributes,
                    oldAttributes: oldTag?.attributes ?? [:]
                )
                // TODO
                //            dom.eventHandlers = tag.eventHandlers
                newNode.dom = dom.asNode()
            } else if let text = newNode.textElement {
                let dom: JSText = try {
                    if let oldNode {
                        let dom = try oldNode.domText.unwrap("oldNode.domText")
                        dom.data = text.value
                        return dom
                    } else {
                        return try document.createTextNode(text.value)
                    }
                }()

                newNode.dom = dom.asNode()
            }

            if let dom = newNode.dom {
                let location = try domNodeLocation(node: newNode)
                if location != dom.location {
                    try dom.remove()
                    try dom.insert(at: location)
                }
            }
        }

        try update(newTree: newNode?.children ?? [], oldTree: oldNode?.children ?? [])

        if newNode == nil {
            if let oldNode {
                try oldNode.dom?.remove()
            }
        }
    }

    private func renderDOMAttributes(
        dom: JSHTMLElement,
        newAttributes: DOMAttributes,
        oldAttributes: DOMAttributes
    ) throws {
        for name in oldAttributes.keys {
            if newAttributes[name] == nil {
                try dom.removeAttribute(name)
            }
        }

        for (name, newValue) in newAttributes {
            let oldValue = oldAttributes[name]

            if newValue != oldValue {
                try dom.setAttribute(name, newValue)
            }
        }
    }
}
