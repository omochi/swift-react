public class JSClosure: JSObject {
    public init(_ body: @escaping ([JSValue]) throws -> JSValue) {
        let native = JSNativeFunction { (this, args) in
            try body(args)
        }
        super.init(native: native)
    }
}
