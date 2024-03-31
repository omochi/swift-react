public class JSFunction: JSObject {
    public override init(native: JSNativeObject) {
        super.init(native: native)
    }

    @discardableResult
    public func callAsFunction(this: JSObject? = nil, arguments: [any ConvertibleToJSValue]) -> JSValue {
        native._call(this: this, arguments: arguments.map { $0.jsValue })
    }

    @discardableResult
    public func callAsFunction(this: JSObject? = nil, _ arguments: (any ConvertibleToJSValue)...) -> JSValue {
        self(this: this, arguments: arguments)
    }

    public func new(arguments: [any ConvertibleToJSValue]) -> JSObject {
        native._new(arguments: arguments.map { $0.jsValue })
    }

    public func new(_ arguments: (any ConvertibleToJSValue)...) -> JSObject {
        new(arguments: arguments)
    }

    public override var jsValue: JSValue { .function(self) }
}
