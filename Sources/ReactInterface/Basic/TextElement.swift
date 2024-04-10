package struct TextElement: Component {
    public init(_ value: String) {
        self.value = value
    }

    public var value: String

    public func render() -> Node { nil }
}
