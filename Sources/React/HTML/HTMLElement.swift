import SRTDOM

public struct HTMLElement: Component {
    public init(
        tagName: String,
        key: AnyHashable? = nil,
        ref: RefObject<JSHTMLElement>? = nil,
        attributes: Attributes? = nil,
        style: Style? = nil,
        listeners: EventListeners? = nil,
        children: [Node] = []
    ) {
        var attributes = attributes

        if let style {
            attributes = (attributes ?? Attributes())
                .style(style.description)
        }

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
    public var attributes: Attributes?
    public var listeners: EventListeners?
    public var children: [Node]

    public var deps: Deps? {
        [
            tagName,
            key,
            ref,
            attributes,
            listeners,
            children.deps
        ]
    }

    public func render() -> Node {
        children
    }
}
