import DOMModule

public func div(
    _ strings: DOMStringAttributes = [:],
    eventHandlers: DOMEventHandlerAttributes = [:],
    @ChildrenBuilder _ children: () -> [Node] = { [] }
) -> TagElement {
    TagElement(
        tagName: "div",
        strings: strings,
        eventHandlers: eventHandlers,
        children: children()
    )
}

public func p(
    _ strings: DOMStringAttributes = [:],
    eventHandlers: DOMEventHandlerAttributes = [:],
    @ChildrenBuilder _ children: () -> [Node] = { [] }
) -> TagElement {
    TagElement(
        tagName: "p",
        strings: strings,
        eventHandlers: eventHandlers,
        children: children()
    )
}

public func h1(
    _ strings: DOMStringAttributes = [:],
    eventHandlers: DOMEventHandlerAttributes = [:],
    @ChildrenBuilder _ children: () -> [Node] = { [] }
) -> TagElement {
    TagElement(
        tagName: "h1",
        strings: strings,
        eventHandlers: eventHandlers,
        children: children()
    )
}

public func h2(
    _ strings: DOMStringAttributes = [:],
    eventHandlers: DOMEventHandlerAttributes = [:],
    @ChildrenBuilder _ children: () -> [Node] = { [] }
) -> TagElement {
    TagElement(
        tagName: "h2",
        strings: strings,
        eventHandlers: eventHandlers,
        children: children()
    )
}

public func h3(
    _ strings: DOMStringAttributes = [:],
    eventHandlers: DOMEventHandlerAttributes = [:],
    @ChildrenBuilder _ children: () -> [Node] = { [] }
) -> TagElement {
    TagElement(
        tagName: "h3",
        strings: strings,
        eventHandlers: eventHandlers,
        children: children()
    )
}

public func h4(
    _ strings: DOMStringAttributes = [:],
    eventHandlers: DOMEventHandlerAttributes = [:],
    @ChildrenBuilder _ children: () -> [Node] = { [] }
) -> TagElement {
    TagElement(
        tagName: "h4",
        strings: strings,
        eventHandlers: eventHandlers,
        children: children()
    )
}

public func button(
    _ strings: DOMStringAttributes = [:],
    eventHandlers: DOMEventHandlerAttributes = [:],
    @ChildrenBuilder _ children: () -> [Node] = { [] }
) -> TagElement {
    TagElement(
        tagName: "button",
        strings: strings,
        eventHandlers: eventHandlers,
        children: children()
    )
}


