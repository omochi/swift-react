import SRTDOM

public func div(
    _ attributes: DOMAttributes = [:],
    listeners: DOMListeners = [:],
    @ChildrenBuilder _ children: () -> [Node] = { [] }
) -> TagElement {
    TagElement(
        tagName: "div",
        attributes: attributes,
        listeners: listeners,
        children: children()
    )
}

public func p(
    _ attributes: DOMAttributes = [:],
    listeners: DOMListeners = [:],
    @ChildrenBuilder _ children: () -> [Node] = { [] }
) -> TagElement {
    TagElement(
        tagName: "p",
        attributes: attributes,
        listeners: listeners,
        children: children()
    )
}

public func h1(
    _ attributes: DOMAttributes = [:],
    listeners: DOMListeners = [:],
    @ChildrenBuilder _ children: () -> [Node] = { [] }
) -> TagElement {
    TagElement(
        tagName: "h1",
        attributes: attributes,
        listeners: listeners,
        children: children()
    )
}

public func h2(
    _ attributes: DOMAttributes = [:],
    listeners: DOMListeners = [:],
    @ChildrenBuilder _ children: () -> [Node] = { [] }
) -> TagElement {
    TagElement(
        tagName: "h2",
        attributes: attributes,
        listeners: listeners,
        children: children()
    )
}

public func h3(
    _ attributes: DOMAttributes = [:],
    listeners: DOMListeners = [:],
    @ChildrenBuilder _ children: () -> [Node] = { [] }
) -> TagElement {
    TagElement(
        tagName: "h3",
        attributes: attributes,
        listeners: listeners,
        children: children()
    )
}

public func h4(
    _ attributes: DOMAttributes = [:],
    listeners: DOMListeners = [:],
    @ChildrenBuilder _ children: () -> [Node] = { [] }
) -> TagElement {
    TagElement(
        tagName: "h4",
        attributes: attributes,
        listeners: listeners,
        children: children()
    )
}

public func button(
    _ attributes: DOMAttributes = [:],
    listeners: DOMListeners = [:],
    @ChildrenBuilder _ children: () -> [Node] = { [] }
) -> TagElement {
    TagElement(
        tagName: "button",
        attributes: attributes,
        listeners: listeners,
        children: children()
    )
}


