import SRTDOM

public struct TagElement: Component {
    public init(
        tagName: String,
        attributes: DOMAttributes = [:],
        eventHandlers: DOMEventHandlerDictionary = [:],
        children: [Node] = []
    ) {
        self.tagName = tagName
        self.attributes = attributes
        self.eventHandlers = eventHandlers
        self.children = children
    }

    public var tagName: String
    public var attributes: DOMAttributes
    public var eventHandlers: DOMEventHandlerDictionary
    public var children: [Node]

    public func render() -> Node {
        NodeCollection(children)
    }
}
