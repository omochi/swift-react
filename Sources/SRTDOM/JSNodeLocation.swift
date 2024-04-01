public struct JSNodeLocation: Hashable {
    public init(
        parent: JSNode,
        next: JSNode?
    ) {
        self.parent = parent
        self.next = next
    }

    public var parent: JSNode
    public var next: JSNode?
}
