import JavaScriptKitMock

public class WebEvent: JSNativeObject {
    public init(
        _ type: String
    ) {
        self.type = type
    }

    public let type: String

    public func _get_property(_ name: String) -> JSValue {
        switch name {
        case "type": type.jsValue
        default: .undefined
        }
    }
}
