public protocol ConvertibleToJSValue {
    var jsValue: JSValue { get }
}

extension Bool: ConvertibleToJSValue {
    public var jsValue: JSValue { .boolean(self) }
}

extension Int: ConvertibleToJSValue {
    public var jsValue: JSValue {
        return .number(Double(self))
    }
}

extension Double: ConvertibleToJSValue {
    public var jsValue: JSValue { .number(self) }
}

extension String: ConvertibleToJSValue {
    public var jsValue: JSValue { .string(JSString(self)) }
}

extension Optional: ConvertibleToJSValue where Wrapped: ConvertibleToJSValue {
    public var jsValue: JSValue { 
        self.map { $0.jsValue } ?? .null
    }
}

extension Array: ConvertibleToJSValue where Element: ConvertibleToJSValue {
    public var jsValue: JSValue {
        let array = JSNativeArray()
        for x in self {
            array.push(x.jsValue)
        }
        return array.jsValue
    }
}
