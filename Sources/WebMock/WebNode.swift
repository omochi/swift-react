import JavaScriptKitMock

public class WebNode: JSNativeObject {
    public init() {
        self._childNodes = WebMutableNodeList()
    }

    private let _childNodes: WebMutableNodeList
    private weak var _parentNode: WebNode?

    public var childNodes: WebNodeList { _childNodes }

    public var firstChild: WebNode? { _childNodes._items.first }

    public var parentNode: WebNode? { _parentNode }

    public func appendChild(_ node: WebNode) {
        _childNodes._items.append(node)
    }

    public func insertBefore(_ node: WebNode, _ ref: WebNode?) {
        if let ref,
           let index = _childNodes.index(of: ref)
        {
            _childNodes._items.insert(node, at: index)
        } else {
            appendChild(node)
        }
    }

    public func removeChild(_ node: WebNode) {
        guard let index = _childNodes.index(of: node) else { return }
        _childNodes._items.remove(at: index)
    }
}
