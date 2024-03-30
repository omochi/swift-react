package struct NodeCollection: Component {
    public init(_ children: [Node]) {
        self.children = children
    }

    public init(_ children: Node...) {
        self.init(children)
    }

    public var children: [Node]

    public func render() -> Node { self }
}
