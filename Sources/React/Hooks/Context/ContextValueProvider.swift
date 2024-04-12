extension ContextValue {
    public typealias Provider = ContextValueProvider<Self>
}

public struct ContextValueProvider<Value: ContextValue>: Component {
    public init(
        key: AnyHashable? = nil,
        value: Value,
        @ChildrenBuilder children: () -> [Node]
    ) {
        self.key = key
        self.value = value
        self.children = children()
    }

    public var key: AnyHashable?
    public var value: Value
    public var children: [Node]

    public var deps: AnyHashable? {
        AnyDeps(
            key,
            value,
            children.deps
        )
    }

    public func render() -> Node {
        children
    }

    public static func _extractGhost(_ input: GhostInput<Self>) -> Ghost {
        var ghost = extractGhostDefault(input)
        ghost.contextValue = (type: Value.self, value: input.component.value)
        return ghost
    }
}
