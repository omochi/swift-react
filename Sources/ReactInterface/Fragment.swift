public struct Fragment: Component {
    public init(children: [Node] = []) {
        self.children = children
    }

    public var children: [Node]

    public func render() -> Node {
        NodeCollection(children)
    }
}
