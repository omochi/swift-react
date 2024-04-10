package import VDOMModule

internal final class Scheduler {
    enum State {
        case idle
        case rendering
    }

    enum Action {
        case renderRoot(Node)
        case update(VNode)

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

    func schedule(action: Action) {
        actionQueue.append(action)
        run()
    }

    func transform(old: VNode, new: VNode?) {
        actionQueue = actionQueue.compactMap { $0.transform(old: old, new: new) }
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
