public struct JSString: Equatable & LosslessStringConvertible & ConvertibleToJSValue {
    public init(_ value: String) {
        self.value = value
    }

    private var value: String

    public var description: String {
        value
    }

    public var jsValue: JSValue { .string(self) }
}
