import SRTJavaScriptKitEx

public struct JSWindow: ConstructibleFromJSValue {
    public init(jsObject: JSObject) {
        self.jsObject = jsObject
    }

    public static func construct(from value: JSValue) -> Self? {
        value.object.map(Self.init(jsObject:))
    }

    public let jsObject: JSObject
    public var jsValue: JSValue { .object(jsObject) }

    public var HTMLElement: JSFunction { .unsafeConstruct(from: jsValue.HTMLElement) }
    public var Text: JSFunction { .unsafeConstruct(from: jsValue.Text) }

    public var document: JSDocument { .unsafeConstruct(from: jsValue.document) }

    public static var global: JSWindow {
        JSWindow(jsObject: JSObject.global)
    }
}
