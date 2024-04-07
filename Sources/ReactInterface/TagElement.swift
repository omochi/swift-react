import SRTDOM

public struct TagElement: Component {
    public init(
        tagName: String,
        attributes: DOMAttributes = [:],
        listeners: DOMListeners = [:],
        children: [Node] = []
    ) {
        self.tagName = tagName
        self.attributes = attributes
        self.listeners = listeners
        self.children = children
    }

    public var tagName: String
    public var attributes: DOMAttributes
    public var listeners: DOMListeners
    public var children: [Node]

    public func render() -> Node {
        NodeCollection(children)
    }
}
