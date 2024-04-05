import JavaScriptKitShim

public struct JSDocument: ConstructibleFromJSValue {
    public init(jsObject: JSObject) {
        self.jsObject = jsObject
    }

    public static func construct(from value: JSValue) -> Self? {
        value.object.map(Self.init(jsObject:))
    }

    public let jsObject: JSObject
    public var jsValue: JSValue { .object(jsObject) }
 
    public func createElement(_ tagName: String) throws -> JSHTMLElement {
        .construct(from: try jsValue.throws.createElement(tagName))!
    }

    public func createTextNode(_ data: String) throws -> JSText {
        .construct(from: try jsValue.throws.createTextNode(data))!
    }
}

