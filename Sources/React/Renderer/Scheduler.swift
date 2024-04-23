internal final class Scheduler {
    enum State {
        case idle
        case paused
        case executing
    }

    enum Action {
        case renderRoot(Node)
        case update(Instance)
        case effect(Effect.Task)

        var update: Instance? {
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
            guard let a = a.update?.owner, let b = b.update?.owner else { return false }
            return isLess(a, b)
        }

        actionQueue.replaceSubrange(..<updates.count, with: updates)
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
