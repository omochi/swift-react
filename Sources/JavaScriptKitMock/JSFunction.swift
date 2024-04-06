import SRTCore

public class JSFunction: JSObject {
    public override init(native: any JSNativeObject) {
        super.init(native: native)
    }

    public func callAsFunction(this: JSObject? = nil, arguments: [any ConvertibleToJSValue]) -> JSValue {
        try! callNative(this: this, arguments: arguments)
    }

    @discardableResult
    public func callAsFunction(this: JSObject? = nil, _ arguments: (any ConvertibleToJSValue)...) -> JSValue {
        self(arguments: arguments)
    }

    public func new(arguments: [any ConvertibleToJSValue]) -> JSObject {
        try! newNative(arguments: arguments)
    }

    public func new(_ arguments: (any ConvertibleToJSValue)...) -> JSObject {
        new(arguments: arguments)
    }

    internal func callNative(this: JSObject? = nil, arguments: [any ConvertibleToJSValue]) throws -> JSValue {
        try native._call(this: this, arguments: arguments.map { $0.jsValue })
    }

    internal func newNative(arguments: [any ConvertibleToJSValue]) throws -> JSObject {
        try native._new(arguments: arguments.map { $0.jsValue })
    }

    public override var jsValue: JSValue { .function(self) }

    public var `throws`: JSThrowingFunction {
        JSThrowingFunction(self)
    }
}

extension JSFunction {
    public convenience init(impl: @escaping (JSObject?, [JSValue]) throws -> JSValue) {
        let native = JSNativeFunction(impl: impl)
        self.init(native: native)
    }
}
