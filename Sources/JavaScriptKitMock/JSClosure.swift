public class JSClosure: JSFunction {
    public init(_ body: @escaping ([JSValue]) -> JSValue) {
        let native = JSNativeFunction { (this, args) in
            body(args)
        }
        super.init(native: native)
    }
}
