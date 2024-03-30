import DOMModule

public struct TagElement: Component {
    public init(
        tagName: String,
        strings: DOMStringAttributes = [:],
        eventHandlers: DOMEventHandlerAttributes = [:],
        children: [Node] = []
    ) {
        self.tagName = tagName
        self.strings = strings
        self.eventHandlers = eventHandlers
        self.children = children
    }

    public var tagName: String
    public var strings: DOMStringAttributes
    public var eventHandlers: DOMEventHandlerAttributes
    public var children: [Node]

    public func render() -> Node {
        NodeCollection(children)
    }
}
