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
        case "length": length.jsValue
        case "item": JSFunction(Self.item).jsValue
        default: .undefined
        }
    }
}

extension WebNodeList: RandomAccessCollection {
    public typealias Element = WebNode
    public typealias Index = Int

    public var startIndex: Int { 0 }
    public var endIndex: Int { items.count }

    public subscript(position: Int) -> WebNode {
        _read {
            yield items[position]
        }
    }

    public func index(of node: WebNode) -> Int? {
        items.firstIndex { $0 === node }
    }
}
