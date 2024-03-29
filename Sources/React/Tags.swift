import Collections

public func div(
    _ attributes: TagAttributes = .init(),
    @ChildrenBuilder _ children: () -> [Node] = { [] }
) -> TagElement {
    TagElement(tagName: "div", attributes: attributes, children: children())
}

public func p(
    _ attributes: TagAttributes = .init(),
    @ChildrenBuilder _ children: () -> [Node] = { [] }
) -> TagElement {
    TagElement(tagName: "p", attributes: attributes, children: children())
}

public func h1(
    _ attributes: TagAttributes = .init(),
    @ChildrenBuilder _ children: () -> [Node] = { [] }
) -> TagElement {
    TagElement(tagName: "h1", attributes: attributes, children: children())
}

public func h2(
    _ attributes: TagAttributes = .init(),
    @ChildrenBuilder _ children: () -> [Node] = { [] }
) -> TagElement {
    TagElement(tagName: "h2", attributes: attributes, children: children())
}

public func h3(
    _ attributes: TagAttributes = .init(),
    @ChildrenBuilder _ children: () -> [Node] = { [] }
) -> TagElement {
    TagElement(tagName: "h3", attributes: attributes, children: children())
}

public func h4(
    _ attributes: TagAttributes = .init(),
    @ChildrenBuilder _ children: () -> [Node] = { [] }
) -> TagElement {
    TagElement(tagName: "h4", attributes: attributes, children: children())
}

public func button(
    _ attributes: TagAttributes = .init(),
    @ChildrenBuilder _ children: () -> [Node] = { [] }
) -> TagElement {
    TagElement(tagName: "button", attributes: attributes, children: children())
}


