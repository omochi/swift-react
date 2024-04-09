import SRTCore

public protocol ConstructibleFromJSValue {
    static func construct(from value: JSValue) -> Self?
}

extension ConstructibleFromJSValue {
    package static func _mustConstruct(from jsValue: JSValue) throws -> Self {
        guard let value = construct(from: jsValue) else {
            throw MessageError("failed to construct \(Self.self), value was \(jsValue)")
        }
        return value
    }

    package static func _mustConstruct(from arguments: [JSValue], at index: Int) throws -> Self {
        let value = try arguments[safe: index].unwrap("arguments[\(index)]")
        return try Self._mustConstruct(from: value)
    }

    package static func _unsafeConstruct(from jsValue: JSValue) -> Self {
        try! _mustConstruct(from: jsValue)
    }
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
    public static func construct(from value: JSValue) -> Optional<Wrapped>? {
        switch value {
        case .null, .undefined: return .some(nil)
        default:
            guard let wrapped = Wrapped.construct(from: value) else { return nil }
            return .some(wrapped)
        }
    }
}

extension Array: ConstructibleFromJSValue where Element: ConstructibleFromJSValue {
    public static func construct(from value: JSValue) -> Array<Element>? {
        guard let object = value.object else { return nil }
        guard let count = Int.construct(from: object.length) else { return nil }
        var result: [Element] = []
        for i in 0..<count {
            guard let element = Element.construct(from: object[i]) else { return nil }
            result.append(element)
        }
        return result
    }
}
