import SRTDOM

public func div(
    key: AnyHashable? = nil,
    ref: RefObject<JSHTMLElement>? = nil,
    attributes: Attributes = [:],
    listeners: EventListeners = [:],
    @ChildrenBuilder _ children: () -> [Node] = { [] }
) -> HTMLElement {
    HTMLElement(
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
) -> HTMLElement {
    HTMLElement(
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
) -> HTMLElement {
    HTMLElement(
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
) -> HTMLElement {
    HTMLElement(
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
) -> HTMLElement {
    HTMLElement(
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
) -> HTMLElement {
    HTMLElement(
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
) -> HTMLElement {
    HTMLElement(
        tagName: "button",
        key: key,
        ref: ref,
        attributes: attributes,
        listeners: listeners,
        children: children()
    )
}


