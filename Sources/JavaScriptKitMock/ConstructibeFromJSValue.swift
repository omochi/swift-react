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

extension Array: ConstructibleFromJSValue where Element: ConstructibleFromJSValue {
    public static func construct(from value: JSValue) -> [Element.Constructed]? {
        guard let object = value.object else { return nil }
        guard let count = Int.construct(from: object.length) else { return nil }
        var result: [Element.Constructed] = []
        for i in 0..<count {
            guard let element = Element.construct(from: object[i]) else { return nil }
            result.append(element)
        }
        return result
    }
}
