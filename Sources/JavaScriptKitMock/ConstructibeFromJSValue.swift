public protocol ConstructibleFromJSValue {
    associatedtype Constructed = Self
    static func construct(from value: JSValue) -> Constructed?
}

extension Bool: ConstructibleFromJSValue {
    public static func construct(from value: JSValue) -> Bool? {
        value.boolean
    }
}

extension String: ConstructibleFromJSValue {
    public static func construct(from value: JSValue) -> String? {
        value.string
    }
}

extension Double: ConstructibleFromJSValue {
    public static func construct(from value: JSValue) -> Self? {
        value.number
    }
}

extension Int: ConstructibleFromJSValue {
    public static func construct(from value: JSValue) -> Int? {
        guard let x = value.number else { return nil }
        return Self(x)
    }
}

extension Optional: ConstructibleFromJSValue where Wrapped: ConstructibleFromJSValue {
    public static func construct(from value: JSValue) -> Wrapped.Constructed? {
        switch value {
        case .null, .undefined: return nil
        default: return Wrapped.construct(from: value)
        }
    }
}
