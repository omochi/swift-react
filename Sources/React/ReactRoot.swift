import SRTCore
import SRTDOM
import SRTJavaScriptKitEx
package import VDOMModule

public final class ReactRoot {
    public init(
        element: JSHTMLElement
    ) {
        self.scheduler = Scheduler()

        self.dom = element
        self.root = nil

        self.window = JSWindow.global
        self.document = window.document

        scheduler.onAction = { [weak self] (action) in
            try self?.run(action: action)
        }
    }

    private let scheduler: Scheduler
    public let dom: JSHTMLElement
    package var root: VNode?
    package var willComponentRender: ((any Component) -> Void)?
    package var didComponentRender: ((any Component) -> Void)?

    private let window: JSWindow
    private let document: JSDocument

    private func run(action: Scheduler.Action) throws {
        switch action {
        case .renderRoot(let node):
            try runRenderRoot(node: node)
        case .update(let node):
            try runUpdate(node: node)
        }
    }

    public func render(node: Node) {
        scheduler.schedule(action: .renderRoot(node))
    }

    package func pause() {
        scheduler.pause()
    }

    package func resume() {
        scheduler.resume()
    }

    private func update(node: VNode) {
        scheduler.schedule(action: .update(node))
    }

    private func runRenderRoot(node: Node) throws {
        let newTree = makeVNode(component: Fragment())
        let newChildren = Nodes.normalize(node: node)
            .map { makeVNode(component: $0) }
        newTree.appendChildren(newChildren)
        try render(newChildren: newChildren, oldChildren: root?.children ?? [])
        self.root = newTree
    }

    private func runUpdate(node oldTree: VNode) throws {
        let newTree = VNode(ghost: oldTree.ghost)
        try render(newTree: newTree, oldTree: oldTree)
        let parent = try oldTree.parent.unwrap("oldTree.parent")
        let index = try parent.index(of: oldTree).unwrap("oldTree index")
        parent.replaceChild(newTree, at: index)
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

        if let oldTree {
            oldTree.new = .some(newTree)
        }

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
                if location != dom.locationRight {
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

            var isDirty = false
            for (_, state) in newTree.ghost.states {
                isDirty = isDirty || state._consumeDirty()

                state._setDidUpdate { [weak self, weak newTree] () in
                    guard let self, let newTree else { return }
                    self.update(node: newTree)
                }
            }

            if isSameDeps, !isDirty {
                doesRenderChildren = false
            }

            if doesRenderChildren {
                let component = newTree.ghost.component

                willComponentRender?(component)
                let newChildrenNode: Node = component.render()
                didComponentRender?(component)

                let newChildren = Nodes.normalize(node: newChildrenNode).map {
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
        for (name, oldHook) in oldTree?.ghost.hooks ?? [:] {
            if let newHook = newTree.ghost.hooks[name] {
                newHook._take(fromAnyHookObject: oldHook)
            }
        }
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

    private func domNodeLocation(node: VNode) throws -> JSNodeLocationRight {
        let parent = try parentDOM(node: node)
        let prev = try prevSiblingDOM(node: node)

        return JSNodeLocationRight(
            parent: parent.asNode(),
            prev: prev
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
