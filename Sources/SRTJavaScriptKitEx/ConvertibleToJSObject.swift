import JavaScriptKitShim

public protocol ConvertibleToJSObject: ConvertibleToJSValue {
    var jsObject: JSObject { get }
}

extension ConvertibleToJSObject {
    public var jsValue: JSValue { 
        get { .object(jsObject) }
        nonmutating set {}
    }
}
