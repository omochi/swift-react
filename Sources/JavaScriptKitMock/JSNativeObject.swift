public protocol JSNativeObject: ConvertibleToJSValue & AnyObject {
    func _get_property(_ name: String) -> JSValue
    func _set_property(_ name: String, _ value: JSValue)

    func _get_index(_ index: Int) -> JSValue
    func _set_index(_ index: Int, _ value: JSValue)

    func _call(this: JSObject?, arguments: [JSValue]) -> JSValue
    func _new(arguments: [JSValue]) -> JSValue
}

extension JSNativeObject {
    public func _get_property(_ name: String) -> JSValue { .undefined }
    public func _set_property(_ name: String, _ value: JSValue) { }

    public func _get_index(_ index: Int) -> JSValue { .undefined }
    public func _set_index(_ index: Int, _ value: JSValue) { }

    public func _call(this: JSObject?, arguments: [JSValue]) -> JSValue { .undefined }
    public func _new(arguments: [JSValue]) -> JSValue { .undefined }
}

extension JSNativeObject {
    public var jsValue: JSValue { .object(JSObject(native: self)) }
}
