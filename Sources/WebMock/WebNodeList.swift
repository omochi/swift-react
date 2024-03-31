import JavaScriptKitMock

public class WebNodeList: JSNativeObject {
    public init() {
    }

    internal var items: [WebNode] { fatalError("unimplemented") }

    public var length: Int { items.count }

    public func item(_ index: Int) -> WebNode? {
        guard 0..<length ~= index else { return nil }
        return items[index]
    }

    public func _get_property(_ name: String) -> JSValue {
        switch name {
        case "length": return length.jsValue
        case "item": return JSFunction(Self.item).jsValue
        default: return .undefined
        }
    }
}

extension WebNodeList {
    internal func index(of node: WebNode) -> Int? {
        items.firstIndex { $0 === node }
    }
}
