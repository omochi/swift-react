public class WebNodeList {
    public init() {
    }

    internal var items: [WebNode] { fatalError("unimplemented") }

    public var length: Int { items.count }

    public func item(_ index: Int) -> WebNode? {
        guard 0..<length ~= index else { return nil }
        return items[index]
    }
}

extension WebNodeList {
    internal func index(of node: WebNode) -> Int? {
        items.firstIndex { $0 === node }
    }
}
