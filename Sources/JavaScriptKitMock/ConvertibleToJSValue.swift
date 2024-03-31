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

