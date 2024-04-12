public protocol ConvertibleToJSObject: ConvertibleToJSValue {
    var jsObject: JSObject { get }
}

extension ConvertibleToJSObject {
    public var jsValue: JSValue { 
        get { .object(jsObject) }
        nonmutating set {}
    }
}

public protocol ConvertibleToJSFunction: ConvertibleToJSObject {
    var jsFunction: JSFunction { get }
}

extension ConvertibleToJSFunction {
    public var jsObject: JSObject { jsFunction }
    
    public var jsValue: JSValue {
        get { .function(jsFunction) }
        nonmutating set {}
    }
}
