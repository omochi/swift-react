import JavaScriptKitShim

public class JSWindow {
    public init(jsObject: JSObject) {
        self.jsObject = jsObject
    }

    public let jsObject: JSObject
    public var jsValue: JSValue { .object(jsObject) }

    public var document: JSDocument {
        JSDocument(jsObject: jsValue.document.object!)
    }

    public static var global: JSWindow {
        JSWindow(jsObject: JSObject.global)
    }
}
