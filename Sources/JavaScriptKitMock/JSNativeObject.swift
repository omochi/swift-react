public protocol JSNativeObject: ConvertibleToJSValue & ConstructibleFromJSValue & AnyObject {
    func _get_property(_ name: String) -> JSValue
    func _set_property(_ name: String, _ value: JSValue)

    func _get_index(_ index: Int) -> JSValue
    func _set_index(_ index: Int, _ value: JSValue)

    func _call(arguments: [JSValue]) -> JSValue
    func _new(arguments: [JSValue]) -> JSValue

    func _isInstanceOf(_ constructor: JSFunction) -> Bool
}

extension JSNativeObject {
    public func _get_property(_ name: String) -> JSValue { .undefined }
    public func _set_property(_ name: String, _ value: JSValue) { }

    public func _get_index(_ index: Int) -> JSValue { .undefined }
    public func _set_index(_ index: Int, _ value: JSValue) { }

    public func _call(arguments: [JSValue]) -> JSValue { .undefined }
    public func _new(arguments: [JSValue]) -> JSValue { .undefined }

    public func _isInstanceOf(_ constructor: JSFunction) -> Bool { false }
}

extension JSNativeObject {
    public static func construct(from value: JSValue) -> Self? {
        guard let object = value.object else { return nil }
        return object.native as? Self
    }
}
