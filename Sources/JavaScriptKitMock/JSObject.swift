@dynamicMemberLookup
public class JSObject: Equatable & ConvertibleToJSValue {
    public init(native: JSNativeObject) {
        self.native = native
    }
    
    internal let native: JSNativeObject
    
    public subscript(_ name: String) -> JSValue {
        get { native._get_property(name) }
        set { native._set_property(name, newValue) }
    }
    
    public subscript(_ index: Int) -> JSValue {
        get { native._get_index(index) }
        set { native._set_index(index, newValue) }
    }
    
    public subscript(dynamicMember name: String) -> JSValue {
        get { self[name] }
        set { self[name] = newValue }
    }
    
    public var jsValue: JSValue { .object(self) }

    public static func ==(a: JSObject, b: JSObject) -> Bool {
        a.native === b.native
    }
}

extension JSObject {
    @_disfavoredOverload
    public subscript(_ name: String) -> ((any ConvertibleToJSValue...) -> JSValue)? {
        guard let function = self[name].function else { return nil }
        return { (arguments: (any ConvertibleToJSValue)...) in
            function(this: self, arguments: arguments)
        }
    }

    @_disfavoredOverload
    public subscript(dynamicMember name: String) -> ((any ConvertibleToJSValue...) -> JSValue)? {
        self[name]
    }
}
