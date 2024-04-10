public struct Fragment: Component {
    public init(children: [Node] = []) {
        self.children = children
    }

    public init(@ChildrenBuilder children: () -> [Node]) {
        let children = children()
        self.init(children: children)
    }

    public var deps: AnyHashable? {
        AnyDeps(children.deps)
    }

    public var children: [Node]

    public func render() -> Node {
        return NodeCollection(children)
    }
}
