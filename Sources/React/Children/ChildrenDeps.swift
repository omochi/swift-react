import SRTCore

private final class UniqueToken: IdentityHashable {}

extension [Node] {
    public var deps: Deps {
        let components = Nodes.normalize(nodes: self)

        var result: [AnyHashable] = []
        for c in components {
            guard let deps = c.deps else {
                return [UniqueToken()]
            }
            result.append(deps)
        }
        return result
    }
}
