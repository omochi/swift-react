public final class JSNativePlainObject: JSNativeObject {
    public init() {}

    private var properties: [String: JSValue] = [:]

    public func _get_property(_ name: String) -> JSValue {
        properties[name] ?? .undefined
    }

    public func _set_property(_ name: String, _ value: JSValue) {
        switch value {
        case .undefined:
            properties[name] = nil
        default:
            properties[name] = value
        }
    }
}
