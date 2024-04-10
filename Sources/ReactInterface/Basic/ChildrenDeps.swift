import SRTCore

public struct ChildrenDeps: Hashable {
    final class Token: IdentityHashable {}

    init(children: [Node]) {
        let components = Nodes.normalize(nodes: children)

        var items: [AnyHashable] = []
        var token: Token? = nil
        for c in components {
            if let deps = c.deps {
                items.append(deps)
            } else {
                token = Token()
                items = []
                break
            }
        }

        self.items = items
        self.token = token
    }

    private var items: [AnyHashable]
    private var token: Token?
}

extension [Node] {
    public var deps: ChildrenDeps {
        ChildrenDeps(children: self)
    }
}
