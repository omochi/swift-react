import JavaScriptKitMock

public final class WebDocument: WebNode {
    public override init() {}

    public func createElement(_ tagName: String) -> WebHTMLElement {
        WebHTMLElement(tagName)
    }

    public func createTextNode(_ data: String) -> WebText {
        WebText(data)
    }

    public override func _get_property(_ name: String) -> JSValue {
        switch name {
        case "createElement": JSFunction(Self.createElement).jsValue
        case "createTextNode": JSFunction(Self.createTextNode).jsValue
        default: super._get_property(name)
        }
    }
}
