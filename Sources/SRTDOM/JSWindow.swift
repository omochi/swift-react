import SRTJavaScriptKitEx

public struct JSWindow: ConvertibleToJSObject & ConstructibleFromJSValue {
    public init(jsObject: JSObject) {
        self.jsObject = jsObject
    }

    public static func construct(from value: JSValue) -> Self? {
        value.object.map(Self.init)
    }

    public var jsObject: JSObject

    public var HTMLElement: JSFunction { .unsafeConstruct(from: jsValue.HTMLElement) }
    public var Text: JSFunction { .unsafeConstruct(from: jsValue.Text) }

    public var MouseEvent: JSMouseEvent.Constructor { .unsafeConstruct(from: jsValue.MouseEvent) }

    public var document: JSDocument { .unsafeConstruct(from: jsValue.document) }

    public func alert(_ message: String) throws { _ = try jsValue.throws.alert(message) }

    public static var global: JSWindow {
        JSWindow(jsObject: JSObject.global)
    }
}
