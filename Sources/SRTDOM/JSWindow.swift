import JavaScriptKitShim

public struct JSWindow {
    public init(jsObject: JSObject) {
        self.jsObject = jsObject
    }

    public let jsObject: JSObject
    public var jsValue: JSValue { .object(jsObject) }

    public var HTMLElement: JSFunction { jsValue.HTMLElement.function! }
    public var Text: JSFunction { jsValue.Text.function! }

    public var document: JSDocument {
        JSDocument(jsObject: jsValue.document.object!)
    }

    public static var global: JSWindow {
        JSWindow(jsObject: JSObject.global)
    }
}
