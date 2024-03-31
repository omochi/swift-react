public final class JSNativeFunction: JSNativeObject {
    public init(impl: @escaping (JSObject?, [JSValue]) -> JSValue) {
        self.impl = impl
    }

    private let impl: (JSObject?, [JSValue]) -> JSValue

    public func _call(this: JSObject?, arguments: [JSValue]) -> JSValue {
        impl(this, arguments)
    }

    public func _new(arguments: [JSValue]) -> JSValue {
        impl(nil, arguments)
    }
}
