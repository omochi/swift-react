import JavaScriptKitMock

public final class WebWindow: JSNativeObject {
    public static func initializeJavaScriptKit() {
        JSObject.global = JSObject(native: WebWindow())
    }

    public init() {
        document = WebDocument()
    }

    public var jsValue: JSValue { .object(JSObject(native: self)) }

    public let document: WebDocument

    public func _get_property(_ name: String) -> JSValue {
        switch name {
        case "HTMLElement": WebHTMLElement.Constructor.shared.jsValue
        case "Text": WebText.Constructor.shared.jsValue
        case "MouseEvent": WebMouseEvent.Constructor.shared.jsValue
        case "document": document.jsValue
        default: .undefined
        }
    }
}
