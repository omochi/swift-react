public protocol JSNativeObject: ConvertibleToJSValue & ConstructibleFromJSValue & AnyObject {
    func _get_property(_ name: String) -> JSValue
    func _set_property(_ name: String, _ value: JSValue)

    func _get_index(_ index: Int) -> JSValue
    func _set_index(_ index: Int, _ value: JSValue)

    func _call(this: JSObject?, arguments: [JSValue]) throws -> JSValue
    func _new(arguments: [JSValue]) throws -> JSObject

    func _isInstanceOf(_ constructor: JSFunction) -> Bool
}

extension JSNativeObject {
    public func _get_property(_ name: String) -> JSValue { .undefined }
    public func _set_property(_ name: String, _ value: JSValue) { }

    public func _get_index(_ index: Int) -> JSValue { .undefined }
    public func _set_index(_ index: Int, _ value: JSValue) { }

    public func _call(this: JSObject?, arguments: [JSValue]) throws -> JSValue { .undefined }
    public func _new(arguments: [JSValue]) throws -> JSObject {
        JSObject(native: JSNativePlainObject())
    }

    public func _isInstanceOf(_ constructor: JSFunction) -> Bool { false }
}

extension JSNativeObject {
    public var jsValue: JSValue { .object(JSObject(native: self)) }

    public static func construct(from value: JSValue) -> Self? {
        guard let object = value.object else { return nil }
        return object.native as? Self
    }
}
