package struct NodeCollection: Element {
    public init(_ children: [Node]) {
        self.children = children
    }

    public init(_ children: Node...) {
        self.init(children)
    }

    @ChildrenProperty public var children: [Node]
}
