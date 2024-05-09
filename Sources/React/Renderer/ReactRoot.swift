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

    private let window: JSWindow
    private let document: JSDocument

    private struct RenderContext {
        var location: JSNodeLocationRight? = nil
        var contextValueHolders: [ObjectIdentifier: ContextValueHolder] = [:]
    }

    private enum RenderStep {
        case renderNode(context: RenderContext, new: VNode?, old: VNode?, isMove: Bool)
        case postRenderNode(new: VNode?, old: VNode?)

        static func renderNode(context: RenderContext, new: VNode?, old: VNode?) -> RenderStep {
            .renderNode(context: context, new: new, old: old, isMove: false)
        }
    }

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
        let context = makeRenderContext(
            context: RenderContext(),
            parent: dom.asNode(),
            holder: nil
        )
        let steps = try renderChildren(
            context: context,
            new: newChildren,
            old: oldChildren
        )
        try executeRenderSteps(steps)
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

        let context = RenderContext(
            location: domLocation,
            contextValueHolders: holders
        )

        let entryStep = RenderStep.renderNode(context: context, new: newTree, old: oldTree)
        try executeRenderSteps([entryStep])
    }

    private static func makeChildren(node: Node) -> [VNode] {
        let nodes = Nodes.normalize(node: node)
        return nodes.map { VNode(component: $0) }
    }

    private func makeRenderContext(
        context: RenderContext,
        parent: JSNode?,
        holder: ContextValueHolder?
    ) -> RenderContext {
        var context = context

        if let parent {
            context.location = JSNodeLocationRight(parent: parent, prev: nil)
        }

        if let holder {
            context.contextValueHolders[ObjectIdentifier(holder.type)] = holder
        }

        return context
    }

    private func domLocation(of node: VNode) throws -> JSNodeLocationRight? {
        let parent: JSNode = try node.parentTagNode?.instance?.dom.unwrap("dom") ?? self.dom.asNode()
        let prev: JSNode? = try node.prevSiblingTagNode?.instance?.dom.unwrap("dom")
        return JSNodeLocationRight(parent: parent, prev: prev)
    }

    private func executeRenderSteps(_ steps: [RenderStep]) throws {
        var steps = steps

        while !steps.isEmpty {
            let step = steps.removeFirst()

            switch step {
            case .renderNode(context: let context, new: let new, old: let old, isMove: let isMove):
                let newSteps = try executeRenderNode(context: context, new: new, old: old, isMove: isMove)
                steps.insert(contentsOf: newSteps, at: 0)
            case .postRenderNode(new: let new, old: let old):
                try executePostRenderNode(new: new, old: old)
            }
        }
    }

    private func executeRenderNode(
        context: RenderContext,
        new newTree: VNode?,
        old oldTree: VNode?,
        isMove: Bool
    ) throws -> [RenderStep] {
        var context = context

        var doesRenderChildren = true

        if let newTree {
            let instance = transferInstance(newTree: newTree, oldTree: oldTree)
            let isFirst = oldTree == nil

            context = try preRender(context: context, tree: newTree, instance: instance, isFirst: isFirst)

            // short circuit
            doesRenderChildren = instance.consumeDirty() ||
                isChanged(new: newTree, old: oldTree)
        }

        var steps: [RenderStep] = []

        if doesRenderChildren {
            steps = try renderChildren(context: context, newTree: newTree, oldTree: oldTree)
        }

        if let newTree {
            context = try skipRenderChildren(context: context, newTree: newTree, oldTree: oldTree, isMove: isMove)
        }

        steps.append(
            .postRenderNode(new: newTree, old: oldTree)
        )

        return steps
    }

    private func executePostRenderNode(
        new newTree: VNode?,
        old oldTree: VNode?
    ) throws {
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

    private func preRender(context: RenderContext, tree: VNode, instance: Instance, isFirst: Bool) throws -> RenderContext {
        var context = context
        try renderDOM(tree: tree, instance: instance)
        context = try moveDOM(context: context, instance: instance)
        try updateContextValue(tree: tree, instance: instance)
        prepareHooks(component: tree.component, instance: instance, isFirst: isFirst)
        subscribeHooks(context: context, instance: instance)
        return context
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

    private func moveDOM(context: RenderContext, instance: Instance) throws -> RenderContext {
        var context = context

        if let location = context.location,
           let dom = instance.dom
        {
            if location != dom.locationRight {
                try dom.remove()
                try dom.insert(at: location)
            }

            context.location?.prev = dom
        }

        return context
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
            for (hook, object) in zip(hooks, instance.hooks) {
                hook._prepareAny(object: object)
            }
        }

        instance.hooks = hooks.map { $0.object }
    }

    private func subscribeHooks(context renderContext: RenderContext, instance: Instance) {
        let updater = { [weak self, weak instance] () -> Void in
            guard let self, let instance else { return }
            instance.markDirty()
            self.scheduleUpdate(instance: instance)
        }

        for context in instance.contextHooks {
            if let holder = renderContext.contextValueHolders[ObjectIdentifier(context.valueType)] {
                context.holder = holder
                context.disposable = holder.emitter.on(handler: updater)
            } else {
                context.holder = nil
                context.disposable = nil
            }
        }

        for state in instance.stateHooks {
            state.didChange = updater
        }
    }

    private func isChanged(new: VNode, old: VNode?) -> Bool {
        if let newDeps = new.component.deps,
           newDeps == old?.component.deps { return false }
        return true
    }

    private func postRender(instance: Instance) throws {
        for effect in instance.effectHooks {
            if let task = effect.taskIfShouldExecute() {
                scheduleEffect(task)
            }
        }
    }

    private func postRenderCleanup(instance: Instance) throws {
        try instance.dom?.remove()

        for effect in instance.effectHooks {
            if let task = effect.cleanupTask() {
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
        context: RenderContext,
        newTree: VNode?,
        oldTree: VNode?
    ) throws -> [RenderStep] {
        if let newTree {
            let component = newTree.component

            willComponentRender?(component)
            let node: Node = component.render()
            didComponentRender?(component)

            let newChildren = Self.makeChildren(node: node)
            newTree.appendChildren(newChildren)
        }

        let newContext = makeRenderContext(
            context: context,
            parent: newTree?.instance?.dom,
            holder: newTree?.instance?.contextValueHolder
        )

        return try renderChildren(
            context: newContext,
            new: newTree?.children ?? [],
            old: oldTree?.children ?? []
        )
    }

    private func renderChildren(
        context: RenderContext,
        new newChildren: [VNode],
        old oldChildren: [VNode]
    ) throws -> [RenderStep] {

        var steps: [RenderStep] = []

        var patchedOldChildren: [VNode?] = oldChildren

        let diff = VNode.match(newChildren: newChildren, oldChildren: oldChildren)

        var nextIndex = 0

        for patch in diff {
            switch patch {
            case .remove(offset: let offset, element: let old, associatedWith: let assoc):
                patchedOldChildren.remove(at: offset)

                if assoc != nil {
                    // process on insert
                } else {
                    steps.append(
                        .renderNode(context: context, new: nil, old: old)
                    )
                }
            case .insert(offset: let offset, element: let newNode, associatedWith: let assoc):
                while nextIndex < offset {
                    let newNode = newChildren[nextIndex]
                    let oldNode = try patchedOldChildren[nextIndex].unwrap("updating oldNode")
                    steps.append(
                        .renderNode(context: context, new: newNode, old: oldNode)
                    )
                    nextIndex += 1
                }

                patchedOldChildren.insert(nil, at: offset)

                let oldNode = assoc.map { oldChildren[$0] }

                steps.append(
                    .renderNode(context: context, new: newNode, old: oldNode, isMove: oldNode != nil)
                )
                nextIndex += 1
            }
        }

        while nextIndex < newChildren.count {
            let newNode = newChildren[nextIndex]
            let oldNode = try patchedOldChildren[nextIndex].unwrap("updating oldNode")
            steps.append(
                .renderNode(context: context, new: newNode, old: oldNode)
            )
            nextIndex += 1
        }

        return steps
    }

    private func skipRenderChildren(
        context: RenderContext, newTree: VNode, oldTree: VNode?, isMove: Bool
    ) throws -> RenderContext {
        var context = context

        newTree.appendChildren(oldTree?.children ?? [])

        if let _ = newTree.instance?.dom { return context }
        guard let location = context.location else { return context }

        let doms = newTree.domChildren

        if isMove {
            for dom in doms {
                try dom.remove()
            }
            for dom in doms {
                try dom.insert(at: location)
                context.location?.prev = dom
            }
        } else {
            if let dom = doms.last {
                context.location?.prev = dom
            }
        }

        return context
    }
}
