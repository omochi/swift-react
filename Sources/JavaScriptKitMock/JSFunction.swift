public class JSFunction: JSObject {
    public override init(native: any JSNativeObject) {
        super.init(native: native)
    }

    @discardableResult
    public func callAsFunction(this: JSObject? = nil, arguments: [any ConvertibleToJSValue]) -> JSValue {
        native._call(this: this, arguments: arguments.map { $0.jsValue }).jsValue
    }

    @discardableResult
    public func callAsFunction(this: JSObject? = nil, _ arguments: (any ConvertibleToJSValue)...) -> JSValue {
        self(this: this, arguments: arguments)
    }

    public func new(arguments: [any ConvertibleToJSValue]) -> JSObject {
        native._new(arguments: arguments.map { $0.jsValue }).object! // 🤷‍♂️
    }

    public func new(_ arguments: (any ConvertibleToJSValue)...) -> JSObject {
        new(arguments: arguments)
    }

    public override var jsValue: JSValue { .function(self) }
}

extension JSFunction {
    public convenience init(impl: @escaping (JSObject?, [JSValue]) -> JSValue) {
        let native = JSNativeFunction(impl: impl)
        self.init(native: native)
    }
}

extension JSFunction {
    public convenience init<
        S: JSNativeObject,
        R: ConvertibleToJSValue
    >(
        _ selector: @escaping (S) -> () -> R
    ) {
        let impl = { (this: JSObject?, arguments: [JSValue]) -> JSValue in
            selector(this! as! S)().jsValue
        }
        self.init(impl: impl)
    }

    public convenience init<
        S: JSNativeObject,
        A0: ConstructibleFromJSValue,
        R: ConvertibleToJSValue
    >(
        _ selector: @escaping (S) -> (A0) -> R
    ) {
        let impl = { (this: JSObject?, arguments: [JSValue]) -> JSValue in
            selector(this! as! S)(
                A0.construct(from: arguments[0])!
            ).jsValue
        }
        self.init(impl: impl)
    }
}
