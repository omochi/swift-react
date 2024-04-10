public struct ForEach: Element {
    public init<S: Sequence>(
        _ elements: S,
        _ body: (S.Element) -> Node
    ) {
        self.children = elements.map(body)
    }

    public var children: [Node]
}
