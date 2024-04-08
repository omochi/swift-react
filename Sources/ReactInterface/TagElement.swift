import SRTDOM

public struct TagElement: Component {
    public init(
        tagName: String,
        attributes: DOMAttributes = [:],
        listeners: DOMEventListeners = [:],
        children: [Node] = []
    ) {
        self.tagName = tagName
        self.attributes = attributes
        self.listeners = listeners
        self.children = children.asAnyNodeArray()
    }

    public var tagName: String
    public var attributes: DOMAttributes
    public var listeners: DOMEventListeners
    public var children: [AnyNode]

    public func render() -> Node {
        NodeCollection(children)
    }
}
