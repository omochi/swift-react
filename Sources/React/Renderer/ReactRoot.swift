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
        case .update(let instance):
            try runUpdate(instance: instance)
        case .effect(let effect):
            effect.run()
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

    private func scheduleUpdate(instance: Instance) {
        scheduler.schedule(action: .update(instance))
    }

    private func scheduleEffect(_ effect: Effect.Task) {
        scheduler.schedule(
            action: .effect(effect)
        )
    }

    private func runRenderRoot(node: Node) throws {
        let newRoot = VNode(component: Fragment())
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

    private func runUpdate(instance: Instance) throws {
        let oldTree = try instance.owner.unwrap("instance.owner")
        let newTree = VNode(component: oldTree.component)

        let parent = try oldTree.parent.unwrap("oldTree.parent")
        let index = try parent.index(of: oldTree).unwrap("oldTree index")
        parent.replaceChild(newTree, at: index)

        let holders = buildContextValueHolders(for: newTree)
        let domLocation = try domLocation(of: newTree)
        try withContextValueHolders(holders) {
            try withLocation(domLocation) {
                try renderNode(new: newTree, old: oldTree)
            }
        }
    }

    private static func makeChildren(node: Node) -> [VNode] {
        let nodes = Nodes.normalize(node: node)
        return nodes.map { VNode(component: $0) }
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

    private func withContextValueHolders(
        _ holders: [ObjectIdentifier: ContextValueHolder],
        _ body: () throws -> Void
    ) rethrows {
        let old = contextValueHolders
        defer {
            contextValueHolders = old
        }
        contextValueHolders = holders
        try body()
    }

    private func withContextValueHolderIfPresent(
        _ holder: ContextValueHolder?,
        _ body: () throws -> Void
    ) rethrows {
        if let holder {
            var holders = contextValueHolders
            holders[ObjectIdentifier(holder.type)] = holder
            try withContextValueHolders(holders, body)
        } else {
            try body()
        }
    }

    private func domLocation(of node: VNode) throws -> JSNodeLocationRight? {
        let parent: JSNode = try node.parentTagNode?.instance?.dom.unwrap("dom") ?? self.dom.asNode()
        let prev: JSNode? = try node.prevSiblingTagNode?.instance?.dom.unwrap("dom")
        return JSNodeLocationRight(parent: parent, prev: prev)
    }

    private func renderNode(
        new newTree: VNode?,
        old oldTree: VNode?,
        isMove: Bool = false
    ) throws {
        var doesRenderChildren = true

        if let newTree {
            let instance = transferInstance(newTree: newTree, oldTree: oldTree)
            let isFirst = oldTree == nil

            try preRender(tree: newTree, instance: instance, isFirst: isFirst)

            // short circuit
            doesRenderChildren = instance.consumeDirty() ||
                isChanged(new: newTree, old: oldTree)
        }

        if doesRenderChildren {
            try renderChildren(newTree: newTree, oldTree: oldTree)
        } else if let newTree {
            try skipRenderChildren(newTree: newTree, oldTree: oldTree, isMove: isMove)
        }

        if let newTree {
            if let instance = newTree.instance {
                try postRender(instance: instance)
            }
        } else if let oldTree {
            if let instance = oldTree.instance {
                try postRenderCleanup(instance: instance)
            }
        }
    }

    private func transferInstance(newTree: VNode, oldTree: VNode?) -> Instance {
        let oldInstance = oldTree?.instance
        oldTree?.instance = nil
        let instance = oldInstance ?? Instance()
        newTree.instance = instance
        return instance
    }

    private func preRender(tree: VNode, instance: Instance, isFirst: Bool) throws {
        try renderDOM(tree: tree, instance: instance)
        try moveDOM(instance: instance)
        try updateContextValue(tree: tree, instance: instance)
        prepareHooks(component: tree.component, instance: instance, isFirst: isFirst)
        subscribeHooks(instance: instance)
    }

    private func renderDOM(tree: VNode, instance: Instance) throws {
        switch tree.component {
        case let newTag as HTMLElement:
            let dom: JSHTMLElement = try {
                if let dom = instance.dom?.asHTMLElement() {
                    return dom
                }

                let dom = try document.createElement(newTag.tagName)
                instance.dom = dom.asNode()
                return dom
            }()

            newTag.ref?.value = dom

            try instance.renderDOMAttributes(attributes: newTag.attributes)
            try instance.renderDOMListeners(listeners: newTag.listeners)
        case let text as TextElement:
            if let dom = instance.dom?.asText() {
                dom.data = text.value
                return
            }
            let dom = try document.createTextNode(text.value)
            instance.dom = dom.asNode()
        default: break
        }
    }

    private func moveDOM(instance: Instance) throws {
        guard let location = currentLocation else { return }

        if let dom = instance.dom {
            if location != dom.locationRight {
                try dom.remove()
                try dom.insert(at: location)
            }

            currentLocation?.prev = dom
        }
    }

    private func updateContextValue(tree: VNode, instance: Instance) throws {
        guard let provider = tree.component as? any _AnyContextValueProvider else { return }

        let type = provider._contextValueType
        let value = provider._contextValue

        let holder: ContextValueHolder = {
            if let holder = instance.contextValueHolder,
               holder.type == type { return holder }

            let holder = ContextValueHolder(type: type)
            instance.contextValueHolder = holder
            return holder
        }()

        holder.value = value
    }

    private func prepareHooks(component: any Component, instance: Instance, isFirst: Bool) {
        let hooks = Components.extractHooks(component)

        if isFirst {
            for hook in hooks {
                hook._prepareAny(object: nil)
            }
        } else {
            for (new, old) in zip(hooks, instance.hooks) {
                new._prepareAny(object: old.object)
            }
        }

        instance.hooks = hooks
    }

    private func subscribeHooks(instance: Instance) {
        let updater = { [weak self, weak instance] () -> Void in
            guard let self, let instance else { return }
            instance.markDirty()
            self.scheduleUpdate(instance: instance)
        }

        for context in instance.contextHooks {
            if let holder = contextValueHolders[ObjectIdentifier(context.valueType)] {
                let dsp = holder.emitter.on(handler: updater)
                context.setHolder(holder, disposable: dsp)
            } else {
                context.setHolder(nil, disposable: nil)
            }
        }

        for state in instance.stateHooks {
            state.setDidChange(updater)
        }
    }

    private func isChanged(new: VNode, old: VNode?) -> Bool {
        if let newDeps = new.component.deps,
           newDeps == old?.component.deps { return false }
        return true
    }

    private func postRender(instance: Instance) throws {
        for effect in instance.effectHooks {
            if let task = effect.effectObject.taskIfShouldExecute() {
                scheduleEffect(task)
            }
        }
    }

    private func postRenderCleanup(instance: Instance) throws {
        try instance.dom?.remove()

        for effect in instance.effectHooks {
            if let task = effect.effectObject.cleanupTask() {
                scheduleEffect(task)
            }
        }
    }

    private func buildContextValueHolders(for node: VNode) -> [ObjectIdentifier: ContextValueHolder] {
        var result: [ObjectIdentifier: ContextValueHolder] = [:]

        // skip self
        var node: VNode? = node.parent
        while let n = node {
            if let holder = n.instance?.contextValueHolder {
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
        newTree: VNode?,
        oldTree: VNode?
    ) throws {
        if let newTree {
            let component = newTree.component

            willComponentRender?(component)
            let node: Node = component.render()
            didComponentRender?(component)

            let newChildren = Self.makeChildren(node: node)
            newTree.appendChildren(newChildren)
        }

        try renderChildren(
            new: newTree?.children ?? [],
            old: oldTree?.children ?? [],
            parent: newTree?.instance?.dom,
            contextValueHolder: newTree?.instance?.contextValueHolder
        )
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

    private func skipRenderChildren(newTree: VNode, oldTree: VNode?, isMove: Bool) throws {
        newTree.appendChildren(oldTree?.children ?? [])

        if let _ = newTree.instance?.dom { return }
        guard let _ = currentLocation else { return }

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
