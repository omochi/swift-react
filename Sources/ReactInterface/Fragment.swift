public struct Fragment: Component {
    public init(children: [Node] = []) {
        self.children = children.asAnyNodeArray()
    }

    public var children: [AnyNode]

    public func render() -> Node {
        NodeCollection(children)
    }
}
