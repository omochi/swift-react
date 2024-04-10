public struct Fragment: Component {
    public init(children: [Node] = []) {
        self.children = children
    }

    public init(@ChildrenBuilder children: () -> [Node]) {
        let children = children()
        self.init(children: children)
    }

    public var children: [Node]

    public func render() -> Node {
        NodeCollection(children)
    }
}
