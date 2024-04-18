import SRTJavaScriptKitEx

public struct JSDocument: ConvertibleToJSObject & ConstructibleFromJSValue {
    public init(jsObject: JSObject) {
        self.jsObject = jsObject
    }

    public static func construct(from value: JSValue) -> Self? {
        value.object.map(Self.init)
    }

    public var jsObject: JSObject

    public var body: JSHTMLElement? {
        get { .unsafeConstruct(from: jsValue.body) }
        nonmutating set { jsValue.body = newValue.jsValue }
    }

    public var documentElement: JSHTMLElement {
        .unsafeConstruct(from: jsValue.documentElement)
    }

    public func createElement(_ tagName: String) throws -> JSHTMLElement {
        try .mustConstruct(from: try jsValue.throws.createElement(tagName))
    }

    public func createTextNode(_ data: String) throws -> JSText {
        try .mustConstruct(from: try jsValue.throws.createTextNode(data))
    }

    public func querySelector(_ selectors: String) throws -> JSHTMLElement? {
        try .mustConstruct(from: try jsValue.throws.querySelector(selectors))
    }

    public func querySelectorAll(_ selectors: String) throws -> JSNodeList {
        try .mustConstruct(from: try jsValue.throws.querySelectorAll(selectors))
    }
}

