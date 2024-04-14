public struct Fragment: Component {
    public init(
        key: AnyHashable? = nil,
        @ChildrenBuilder children: () -> [Node] = { [] }
    ) {
        self.key = key
        self.children = children()
    }

    public var deps: Deps? {
        [key, children.deps]
    }

    public var key: AnyHashable?
    public var children: [Node]

    public func render() -> Node {
        children
    }
}
