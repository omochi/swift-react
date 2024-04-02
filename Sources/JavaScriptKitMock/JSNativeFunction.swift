public final class JSNativeFunction: JSNativeObject {
    public init(
        impl: @escaping (JSObject?, [JSValue]) -> JSValue,
        this: JSObject? = nil
    ) {
        self.impl = impl
        self.this = this
    }

    private let impl: (JSObject?, [JSValue]) -> JSValue
    private let this: JSObject?

    public func bind(_ this: JSObject) -> JSNativeFunction {
        JSNativeFunction(impl: impl, this: this)
    }

    public var jsValue: JSValue { .function(JSFunction(native: self)) }

    public func _call(arguments: [JSValue]) -> JSValue {
        impl(this, arguments)
    }

    public func _new(arguments: [JSValue]) -> JSValue {
        impl(nil, arguments)
    }

    public var jsFunction: JSFunction {
        JSFunction(native: self)
    }
}
