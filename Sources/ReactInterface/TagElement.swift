import Collections

public struct TagElement: Component {
    public init(
        tagName: String,
        attributes: TagAttributes = .init(),
        children: [Node] = []
    ) {
        self.tagName = tagName
        self.attributes = attributes
        self.children = children
    }

    public var tagName: String
    public var attributes: TagAttributes
    public var children: [Node]

    public func render() -> Node {
        NodeCollection(children)
    }
}
