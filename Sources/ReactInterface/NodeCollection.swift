package struct NodeCollection: Element {
    public init(_ children: [Node]) {
        self.children = children.asAnyNodeArray()
    }

    public init(_ children: Node...) {
        self.init(children)
    }

    public var children: [AnyNode]
}
