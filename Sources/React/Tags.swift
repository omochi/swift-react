import SRTDOM

public func div(
    key: AnyHashable? = nil,
    ref: RefObject<JSHTMLElement>? = nil,
    attributes: Attributes = [:],
    listeners: EventListeners = [:],
    @ChildrenBuilder _ children: () -> [Node] = { [] }
) -> TagElement {
    TagElement(
        tagName: "div",
        key: key,
        ref: ref,
        attributes: attributes,
        listeners: listeners,
        children: children()
    )
}

public func p(
    key: AnyHashable? = nil,
    ref: RefObject<JSHTMLElement>? = nil,
    attributes: Attributes = [:],
    listeners: EventListeners = [:],
    @ChildrenBuilder _ children: () -> [Node] = { [] }
) -> TagElement {
    TagElement(
        tagName: "p",
        key: key,
        ref: ref,
        attributes: attributes,
        listeners: listeners,
        children: children()
    )
}

public func h1(
    key: AnyHashable? = nil,
    ref: RefObject<JSHTMLElement>? = nil,
    attributes: Attributes = [:],
    listeners: EventListeners = [:],
    @ChildrenBuilder _ children: () -> [Node] = { [] }
) -> TagElement {
    TagElement(
        tagName: "h1",
        key: key,
        ref: ref,
        attributes: attributes,
        listeners: listeners,
        children: children()
    )
}

public func h2(
    key: AnyHashable? = nil,
    ref: RefObject<JSHTMLElement>? = nil,
    attributes: Attributes = [:],
    listeners: EventListeners = [:],
    @ChildrenBuilder _ children: () -> [Node] = { [] }
) -> TagElement {
    TagElement(
        tagName: "h2",
        key: key,
        ref: ref,
        attributes: attributes,
        listeners: listeners,
        children: children()
    )
}

public func h3(
    key: AnyHashable? = nil,
    ref: RefObject<JSHTMLElement>? = nil,
    attributes: Attributes = [:],
    listeners: EventListeners = [:],
    @ChildrenBuilder _ children: () -> [Node] = { [] }
) -> TagElement {
    TagElement(
        tagName: "h3",
        key: key,
        ref: ref,
        attributes: attributes,
        listeners: listeners,
        children: children()
    )
}

public func h4(
    key: AnyHashable? = nil,
    ref: RefObject<JSHTMLElement>? = nil,
    attributes: Attributes = [:],
    listeners: EventListeners = [:],
    @ChildrenBuilder _ children: () -> [Node] = { [] }
) -> TagElement {
    TagElement(
        tagName: "h4",
        key: key,
        ref: ref,
        attributes: attributes,
        listeners: listeners,
        children: children()
    )
}

public func button(
    key: AnyHashable? = nil,
    ref: RefObject<JSHTMLElement>? = nil,
    attributes: Attributes = [:],
    listeners: EventListeners = [:],
    @ChildrenBuilder _ children: () -> [Node] = { [] }
) -> TagElement {
    TagElement(
        tagName: "button",
        key: key,
        ref: ref,
        attributes: attributes,
        listeners: listeners,
        children: children()
    )
}


