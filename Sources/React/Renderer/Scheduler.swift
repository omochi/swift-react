internal final class Scheduler {
    enum State {
        case idle
        case paused
        case executing
    }

    enum Action {
        case renderRoot(Node)
        case update(VNode)
        case effect(cleanup: Effect.Cleanup?, setup: Effect.Setup?)

        var update: VNode? {
            switch self {
            case .update(let x): x
            default: nil
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
        case .paused: 
            state = .idle
            run()
        case .idle,
                .executing: return
        }
    }

    func pause() {
        switch state {
        case .idle: state = .paused
        case .paused: return
        case .executing: preconditionFailure("cant pause now")
        }
    }

    func schedule(action: Action) {
        actionQueue.append(action)
        run()
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
            case .renderRoot,
                    .effect: break
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
                        .update,
                        .effect:
                    state = .executing
                    run(action: action)
                    updateActions()
                    state = .idle
                }
            case .paused:
                return
            case .executing:
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
