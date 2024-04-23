extension ContextValue {
    public typealias Provider = ContextValueProvider<Self>
}

public struct ContextValueProvider<Value: ContextValue>: Component & _AnyContextValueProvider {
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

    public var deps: Deps? {
        [
            key,
            value,
            children.deps
        ]
    }

    public func render() -> Node {
        children
    }

    var _contextValueType: any ContextValue.Type { Value.self }
    var _contextValue: any ContextValue { value }

    public static func _extractGhost(_ input: GhostInput<Self>) -> Ghost {
        var ghost = extractGhostDefault(input)
        ghost.contextValue = (type: Value.self, value: input.component.value)
        return ghost
    }
}

internal protocol _AnyContextValueProvider {
    var _contextValueType: any ContextValue.Type { get }
    var _contextValue: any ContextValue { get }
}
