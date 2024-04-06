import SRTCore
import JavaScriptKitMock

public class WebNode: WebEventTarget & CustomStringConvertible {
    public override init() {
        self._childNodes = WebMutableNodeList()
        super.init()
    }

    private let _childNodes: WebMutableNodeList
    private weak var _parentNode: WebNode?

    public var childNodes: WebNodeList { _childNodes }

    public var firstChild: WebNode? { _childNodes._items.first }

    public var nextSibling: WebNode? { 
        guard let parent = _parentNode else { return nil }
        guard let index = parent._childNodes.index(of: self) else { return nil }
        return parent._childNodes.item(index + 1)
    }

    public var parentNode: WebNode? { _parentNode }

    public func appendChild(_ node: WebNode) {
        _childNodes._items.append(node)
        node._parentNode = self
    }

    public func insertBefore(_ node: WebNode, _ ref: WebNode?) throws {
        if let ref {
            let index = try _childNodes.index(of: ref).unwrap("ref")
            _childNodes._items.insert(node, at: index)
            node._parentNode = self
        } else {
            appendChild(node)
        }
    }

    public func remove() {
        parentNode?.removeChild(self)
    }

    public func removeChild(_ node: WebNode) {
        guard let index = _childNodes.index(of: node) else { return }
        _childNodes._items.remove(at: index)
        node._parentNode = nil
    }

    public var description: String {
        let p = PrettyPrinter()
        write(to: p)
        return p.output
    }

    internal func write(to p: PrettyPrinter) {
        fatalError()
    }

    public override func _get_property(_ name: String) -> JSValue {
        switch name {
        case "childNodes": childNodes.jsValue
        case "firstChild": firstChild.jsValue
        case "nextSibling": nextSibling.jsValue
        case "parentNode": parentNode.jsValue
        case "description": description.jsValue
        case "appendChild": JSFunction(Self.appendChild).jsValue
        case "insertBefore": JSFunction(Self.insertBefore).jsValue
        case "remove": JSFunction(Self.remove).jsValue
        case "removeChild": JSFunction(Self.removeChild).jsValue
        default: super._get_property(name)
        }
    }
}
