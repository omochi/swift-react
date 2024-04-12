internal final class Scheduler {
    enum State {
        case idle
        case paused
        case rendering
    }

    enum Action {
        case renderRoot(Node)
        case update(VNode)

        var update: VNode? {
            switch self {
            case .update(let x): x
            default: nil
            }
        }

        func transform(old: VNode, new: VNode?) -> Action? {
            switch self {
            case .renderRoot: 
                return self
            case .update(let node):
                // identify
                guard node === old else { return self }

                if let new {
                    return .update(new)
                } else {
                    return nil
                }
            }
        }
    }

    init() {
        state = .idle
        actionQueue = []
    }

    private var state: State
    private var actionQueue: [Action]

    var onAction: ((Action) throws -> Void)?

    func resume() {
        switch state {
        case .idle: return
        case .paused: 
            state = .idle
            run()
        case .rendering: return
        }
    }

    func pause() {
        switch state {
        case .idle: state = .paused
        case .paused: return
        case .rendering: preconditionFailure("cant pause now")
        }
    }

    func schedule(action: Action) {
        actionQueue.append(action)
        run()
    }

    func transform(old: VNode, new: VNode?) {
        actionQueue = actionQueue.compactMap { $0.transform(old: old, new: new) }
    }

    private func reorderActions() {
        var updates = Array(actionQueue.prefix { $0.update != nil })
        if updates.isEmpty { return }

        func isLess(_ a: VNode, _ b: VNode) -> Bool {
            if a.isDescendant(of: b) {
                return false
            }
            if b.isDescendant(of: a) {
                return true
            }
            return false
        }

        updates.sort { (a, b) in
            guard let a = a.update, let b = b.update else { return false }
            return isLess(a, b)
        }

        actionQueue.replaceSubrange(..<updates.count, with: updates)
    }

    private func updateActions() {
        actionQueue = actionQueue.compactMap { (action) in
            switch action {
            case .renderRoot: break
            case .update(let node):
                guard case .some(let new) = node.new else { break }

                return new.map { .update($0) }
            }
            return action
        }
    }

    private func run() {
        while true {
            switch state {
            case .idle:
                reorderActions()

                guard let action = actionQueue.first else {
                    return
                }
                actionQueue.remove(at: 0)

                switch action {
                case .renderRoot,
                        .update:
                    state = .rendering
                    run(action: action)
                    updateActions()
                    state = .idle
                }
            case .paused:
                return
            case .rendering:
                return
            }
        }
    }

    private func run(action: Action) {
        do {
            try onAction?(action)
        } catch {
            // TODO:
            print("\(error)")
        }
    }
}
