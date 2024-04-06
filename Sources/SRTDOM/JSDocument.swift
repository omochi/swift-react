import SRTJavaScriptKitEx

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
        try .mustConstruct(from: try jsValue.throws.createElement(tagName))
    }

    public func createTextNode(_ data: String) throws -> JSText {
        try .mustConstruct(from: try jsValue.throws.createTextNode(data))
    }
}

