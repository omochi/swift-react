import SRTCore

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

    public func isInstanceOf(_ constructor: JSFunction) -> Bool {
        native._isInstanceOf(constructor)
    }

    public static var global: JSObject = JSObject(native: JSNativePlainObject())

    public static func ==(a: JSObject, b: JSObject) -> Bool {
        a.native === b.native
    }

    public func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }

    public var jsValue: JSValue { .object(self) }

    public var throwing: JSThrowingObject { .init(self) }

    public static func construct(from value: JSValue) -> Self? {
        switch value {
        case .object(let x): return x as? Self
        case .function(let x): return x as? Self
        default: return nil
        }
    }

    internal func castNative<S>(to toType: S.Type) throws -> S {
        guard let value = native as? S else {
            let fromType = type(of: native)
            throw MessageError("failed to cast to \(toType), value was \(fromType)")
        }
        return value
    }

    // 本家にこれが無いけど
    public func _call(this: JSObject? = nil, arguments: [any ConvertibleToJSValue]) throws -> JSValue {
        try native._call(this: this, arguments: arguments.map { $0.jsValue })
    }
}
