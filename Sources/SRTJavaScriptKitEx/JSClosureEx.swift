import JavaScriptKitShim

extension JSClosure {

#if USES_JAVASCRIPT_KIT_MOCK
    public func asFunction() -> JSThrowingFunction {
        let fn = native as! JSNativeFunction
        return JSFunction(native: fn).throws
    }
#else
    public func asFunction() -> JSThrowingFunction {
        var buffer: JSValue = Array<Int>([0]).jsValue
        buffer[0] = self.jsValue
        let fn = JSFunction.unsafeConstruct(from: buffer[0])
        return fn.throws
    }
#endif

}
