import JavaScriptKitMock

public final class WebWindow: JSNativeObject {
    public init() {
        self.document = WebDocument()
    }

    public let document: WebDocument

    public func _get_property(_ name: String) -> JSValue {
        switch name {
        case "document": document.jsValue
        default: .undefined
        }
    }
}
