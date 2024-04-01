import SRTDOM

public func div(
    _ attributes: DOMAttributes = [:],
    eventHandlers: DOMEventHandlerDictionary = [:],
    @ChildrenBuilder _ children: () -> [Node] = { [] }
) -> TagElement {
    TagElement(
        tagName: "div",
        attributes: attributes,
        eventHandlers: eventHandlers,
        children: children()
    )
}

public func p(
    _ attributes: DOMAttributes = [:],
    eventHandlers: DOMEventHandlerDictionary = [:],
    @ChildrenBuilder _ children: () -> [Node] = { [] }
) -> TagElement {
    TagElement(
        tagName: "p",
        attributes: attributes,
        eventHandlers: eventHandlers,
        children: children()
    )
}

public func h1(
    _ attributes: DOMAttributes = [:],
    eventHandlers: DOMEventHandlerDictionary = [:],
    @ChildrenBuilder _ children: () -> [Node] = { [] }
) -> TagElement {
    TagElement(
        tagName: "h1",
        attributes: attributes,
        eventHandlers: eventHandlers,
        children: children()
    )
}

public func h2(
    _ attributes: DOMAttributes = [:],
    eventHandlers: DOMEventHandlerDictionary = [:],
    @ChildrenBuilder _ children: () -> [Node] = { [] }
) -> TagElement {
    TagElement(
        tagName: "h2",
        attributes: attributes,
        eventHandlers: eventHandlers,
        children: children()
    )
}

public func h3(
    _ attributes: DOMAttributes = [:],
    eventHandlers: DOMEventHandlerDictionary = [:],
    @ChildrenBuilder _ children: () -> [Node] = { [] }
) -> TagElement {
    TagElement(
        tagName: "h3",
        attributes: attributes,
        eventHandlers: eventHandlers,
        children: children()
    )
}

public func h4(
    _ attributes: DOMAttributes = [:],
    eventHandlers: DOMEventHandlerDictionary = [:],
    @ChildrenBuilder _ children: () -> [Node] = { [] }
) -> TagElement {
    TagElement(
        tagName: "h4",
        attributes: attributes,
        eventHandlers: eventHandlers,
        children: children()
    )
}

public func button(
    _ attributes: DOMAttributes = [:],
    eventHandlers: DOMEventHandlerDictionary = [:],
    @ChildrenBuilder _ children: () -> [Node] = { [] }
) -> TagElement {
    TagElement(
        tagName: "button",
        attributes: attributes,
        eventHandlers: eventHandlers,
        children: children()
    )
}


