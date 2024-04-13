import SRTCore
import SRTDOM
import SRTJavaScriptKitEx

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

    private var currentLocation: JSNodeLocationRight?
    private var contextValueHolders: [ObjectIdentifier: ContextValueHolder] = [:]

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

    private func scheduleUpdate(node: VNode) {
        scheduler.schedule(action: .update(node))
    }

    private func runRenderRoot(node: Node) throws {
        let newRoot = Self.makeVNode(component: Fragment())
        let newChildren = Self.makeChildren(node: node)
        newRoot.appendChildren(newChildren)
        let oldChildren = root?.children ?? []
        try renderChildren(
            new: newChildren,
            old: oldChildren,
            parent: dom.asNode(),
            contextValueHolder: nil
        )
        self.root = newRoot
    }

    private func runUpdate(node oldTree: VNode) throws {
        let newTree = VNode(ghost: oldTree.ghost)

        let parent = try oldTree.parent.unwrap("oldTree.parent")
        let index = try parent.index(of: oldTree).unwrap("oldTree index")
        parent.replaceChild(newTree, at: index)

        let domLocation = try domLocation(of: newTree)

        try withLocation(domLocation) {
            try renderNode(new: newTree, old: oldTree)
        }
    }

    private static func makeVNode<C: Component>(component: C) -> VNode {
        let ghost = C._extractGhost(
            .init(component: component)
        )
        return VNode(ghost: ghost)
    }

    private static func makeChildren(node: Node) -> [VNode] {
        let nodes = Nodes.normalize(node: node)
        return nodes.map { makeVNode(component: $0) }
    }

    private func withLocation(_ location: JSNodeLocationRight?, _ body: () throws -> Void) rethrows {
        let old = currentLocation
        defer {
            currentLocation = old
        }
        currentLocation = location
        try body()
    }

    private func withLocationIfParent(_ parent: JSNode?, _ body: () throws -> Void) rethrows {
        if let parent {
            let location = JSNodeLocationRight(parent: parent, prev: nil)
            try withLocation(location, body)
        } else {
            try body()
        }
    }

    private func withContextValueHolderIfPresent(
        _ holder: ContextValueHolder?,
        _ body: () throws -> Void
    ) rethrows {
        if let holder {
            let old = contextValueHolders
            defer {
                contextValueHolders = old
            }
            contextValueHolders[ObjectIdentifier(holder.type)] = holder
            try body()
        } else {
            try body()
        }
    }

    private func domLocation(of node: VNode) throws -> JSNodeLocationRight? {
        let parent: JSNode = try node.parentTagNode?.dom.unwrap("dom") ?? self.dom.asNode()
        let prev: JSNode? = try node.prevSiblingTagNode?.dom.unwrap("dom")
        return JSNodeLocationRight(parent: parent, prev: prev)
    }

    private func renderNode(
        new newTree: VNode?,
        old oldTree: VNode?,
        isMove: Bool = false
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

            if let location = currentLocation {
                if let dom = newTree.dom {
                    if location != dom.locationRight {
                        try dom.remove()
                        try dom.insert(at: location)
                    }

                    currentLocation?.prev = dom
                }
            }

            if let contextValue = newTree.ghost.contextValue {
                let holder: ContextValueHolder = if let oldHolder = oldTree?.contextValueHolder,
                    oldHolder.type == contextValue.type
                {
                    oldHolder
                } else {
                    ContextValueHolder(type: contextValue.type)
                }

                newTree.contextValueHolder = holder
                holder.value = contextValue.value
            }

            renderGhost(newTree: newTree, oldTree: oldTree)

            let updater = { [weak self, weak newTree] () -> Void in
                guard let self, let newTree else { return }
                newTree.markDirty()
                self.scheduleUpdate(node: newTree)
            }

            for (_, context) in newTree.ghost.contexts {
                let holder = self.contextValueHolder(for: newTree, type: context._valueType)
                let dsp: (any Disposable)? = holder?.emitter.on(handler: updater)
                context._setHolder(holder, disposable: dsp)
            }

            for (_, state) in newTree.ghost.states {
                state._setDidChange(updater)
            }

            var isDirty = newTree.consumeDirty()

            if !isDirty {
                if let newDeps = newTree.ghost.component.deps,
                   let oldDeps = oldTree?.ghost.component.deps,
                    newDeps == oldDeps
                {
                    // same
                } else {
                    isDirty = true
                }
            }

            if isDirty {
                let component = newTree.ghost.component

                willComponentRender?(component)
                let node: Node = component.render()
                didComponentRender?(component)

                let newChildren = Self.makeChildren(node: node)
                newTree.appendChildren(newChildren)
            } else {
                newTree.appendChildren(oldTree?.children ?? [])
                doesRenderChildren = false
            }
        }

        if doesRenderChildren {
            try renderChildren(
                new: newTree?.children ?? [],
                old: oldTree?.children ?? [],
                parent: newTree?.dom,
                contextValueHolder: newTree?.contextValueHolder
            )
        } else {
            if let newTree,
                newTree.dom == nil,
                let _ = currentLocation
            {
                let doms = newTree.domChildren
                if isMove {
                    for dom in doms {
                        try dom.remove()
                    }
                    for dom in doms {
                        try dom.insert(at: currentLocation!)
                        currentLocation!.prev = dom
                    }
                } else {
                    if let dom = doms.last {
                        currentLocation!.prev = dom
                    }
                }
            }
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

    private func contextValueHolder(
        for node: VNode,
        type: any ContextValue.Type
    ) -> ContextValueHolder? {
        func find() -> ContextValueHolder? {
            var node: VNode? = node

            while let n = node {
                if let holder = n.contextValueHolder,
                   holder.type == type
                {
                    return holder
                }

                node = n.parent
            }

            return nil
        }

        // TODO: cache table
        return find()
    }

    private func buildContextValueHolders(for node: VNode) -> [ObjectIdentifier: ContextValueHolder] {
        var result: [ObjectIdentifier: ContextValueHolder] = [:]

        // skip self
        var node: VNode? = node.parent
        while let n = node {
            if let holder = n.contextValueHolder {
                let typeID = ObjectIdentifier(holder.type)
                if result[typeID] == nil {
                    result[typeID] = holder
                }
            }

            node = n.parent
        }

        return result
    }

    private func renderChildren(
        new: [VNode],
        old: [VNode],
        parent: JSNode?,
        contextValueHolder: ContextValueHolder?
    ) throws {
        try withContextValueHolderIfPresent(contextValueHolder) {
            try withLocationIfParent(parent) {
                try renderChildren(new: new, old: old)
            }
        }
    }

    private func renderChildren(
        new newChildren: [VNode],
        old oldChildren: [VNode]
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
                    try renderNode(new: nil, old: oldNode)
                }
            case .insert(offset: let offset, element: let newNode, associatedWith: let source):
                for index in nextIndex..<offset {
                    let newNode = newChildren[index]
                    let oldNode = try patchedOldChildren[index].unwrap("updating oldNode")
                    try renderNode(new: newNode, old: oldNode)
                }
                nextIndex = offset + 1

                patchedOldChildren.insert(nil, at: offset)

                let oldNode = source.map { oldChildren[$0] }
                try renderNode(new: newNode, old: oldNode, isMove: oldNode != nil)
            }
        }

        for index in nextIndex..<newChildren.count {
            let newNode = newChildren[index]
            let oldNode = try patchedOldChildren[index].unwrap("updating oldNode")
            try renderNode(new: newNode, old: oldNode)
        }
        nextIndex = newChildren.count
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
