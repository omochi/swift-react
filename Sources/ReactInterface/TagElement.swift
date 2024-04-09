import SRTDOM

public struct TagElement: Component {
    public init(
        tagName: String,
        key: AnyHashable? = nil,
        ref: RefObject<JSHTMLElement>? = nil,
        attributes: Attributes = [:],
        listeners: EventListeners = [:],
        children: [Node] = []
    ) {
        self.tagName = tagName
        self.key = key
        self.ref = ref
        self.attributes = attributes
        self.listeners = listeners
        self.children = children
    }

    public var tagName: String
    public var key: AnyHashable?
    public var ref: RefObject<JSHTMLElement>?
    public var attributes: Attributes
    public var listeners: EventListeners
    @ChildrenProperty public var children: [Node]

    public func render() -> Node {
        NodeCollection(children)
    }
}
