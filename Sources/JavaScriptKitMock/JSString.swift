public struct JSString: Equatable & LosslessStringConvertible & ConvertibleToJSValue & ConstructibleFromJSValue {
    public init(_ value: String) {
        self.value = value
    }

    private var value: String

    public var description: String {
        value
    }

    public var jsValue: JSValue { .string(self) }

    public static func construct(from value: JSValue) -> JSString? {
        value.jsString
    }
}
