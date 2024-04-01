public typealias JavaScriptObjectRef = ObjectIdentifier

@dynamicMemberLookup
public class JSObject: Equatable & Hashable & ConvertibleToJSValue & ConstructibleFromJSValue {
    public init(native: any JSNativeObject) {
        self.native = native
    }
    
    public let native: any JSNativeObject

    public var id: JavaScriptObjectRef { ObjectIdentifier(native) }

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

    public static var global: JSObject = JSObject(native: JSNativePlainObject())

    public static func ==(a: JSObject, b: JSObject) -> Bool {
        a.native === b.native
    }

    public func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }

    public var jsValue: JSValue { .object(self) }

    public static func construct(from value: JSValue) -> JSObject? {
        value.object
    }
}

extension JSObject {
    @_disfavoredOverload
    public subscript(_ name: String) -> JSFunction? {
        guard let function = self[name].function?.native as? JSNativeFunction else { return nil }
        return function.bind(self).jsFunction
    }

    @_disfavoredOverload
    public subscript(dynamicMember name: String) -> JSFunction? {
        self[name]
    }
}
