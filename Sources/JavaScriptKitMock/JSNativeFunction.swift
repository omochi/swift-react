public final class JSNativeFunction: JSNativeObject {
    public init(
        impl: @escaping (JSObject?, [JSValue]) throws -> JSValue
    ) {
        self.impl = impl
    }

    private let impl: (JSObject?, [JSValue]) throws -> JSValue

    public var jsValue: JSValue { .function(JSFunction(native: self)) }

    public func _call(this: JSObject?, arguments: [JSValue]) throws -> JSValue {
        try impl(this, arguments)
    }

    public func _new(arguments: [JSValue]) throws -> JSValue {
        try impl(nil, arguments)
    }

    public var jsFunction: JSFunction {
        JSFunction(native: self)
    }
}
