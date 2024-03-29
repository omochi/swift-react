public struct DOMLocation: Hashable {
    public init(
        parent: DOMParentNode,
        index: Int
    ) {
        self.parent = parent
        self.index = index
    }

    public var parent: DOMParentNode
    public var index: Int

    private var value: (ObjectIdentifier, Int) {
        (ObjectIdentifier(parent), index)
    }

    public static func ==(a: DOMLocation, b: DOMLocation) -> Bool {
        a.value == b.value
    }

    public func hash(into hasher: inout Hasher) {
        let value = self.value
        hasher.combine(value.0)
        hasher.combine(value.1)
    }
}
