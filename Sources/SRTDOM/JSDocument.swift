import JavaScriptKitShim

public struct JSDocument {
    public init(jsObject: JSObject) {
        self.jsObject = jsObject
    }

    public let jsObject: JSObject
    public var jsValue: JSValue { .object(jsObject) }
 
    public func createElement(_ tagName: String) -> JSHTMLElement {
        JSHTMLElement(jsObject: jsValue.createElement(tagName).object!)
    }

    public func createTextNode(_ data: String) -> JSText {
        JSText(jsObject: jsValue.createTextNode(data).object!)
    }
}

