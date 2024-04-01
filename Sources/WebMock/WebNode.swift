import SRTCore
import JavaScriptKitMock

public class WebNode: JSNativeObject & CustomStringConvertible {
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

    public var description: String {
        let p = PrettyPrinter()
        print(to: p)
        return p.output
    }

    internal func print(to p: PrettyPrinter) {
        fatalError()
    }

    public func _get_property(_ name: String) -> JSValue {
        switch name {
        case "childNodes": childNodes.jsValue
        case "firstChild": firstChild.jsValue
        case "parentNode": parentNode.jsValue
        case "description": description.jsValue
        case "appendChild": JSFunction(Self.appendChild).jsValue
        case "insertBefore": JSFunction(Self.insertBefore).jsValue
        case "removeChild": JSFunction(Self.removeChild).jsValue
        default: .undefined
        }
    }
}
