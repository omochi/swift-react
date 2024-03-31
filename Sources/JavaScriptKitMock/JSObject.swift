@dynamicMemberLookup
public class JSObject: Equatable & ConvertibleToJSValue & ConstructibleFromJSValue {
    public init(native: any JSNativeObject) {
        self.native = native
    }
    
    public let native: any JSNativeObject

    public subscript(_ name: String) -> JSValue {
        get { native._get_property(name).jsValue }
        set { native._set_property(name, newValue) }
    }
    
    public subscript(_ index: Int) -> JSValue {
        get { native._get_index(index).jsValue }
        set { native._set_index(index, newValue) }
    }
    
    public subscript(dynamicMember name: String) -> JSValue {
        get { self[name] }
        set { self[name] = newValue }
    }

    public static func ==(a: JSObject, b: JSObject) -> Bool {
        a.native === b.native
    }

    public var jsValue: JSValue { .object(self) }

    public static func construct(from value: JSValue) -> JSObject? {
        value.object
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
