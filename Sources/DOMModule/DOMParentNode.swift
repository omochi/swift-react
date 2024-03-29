public class DOMParentNode: DOMNode {
    internal override init() {}

    public var children: [DOMNode] {
        get { _children }
        set {
            _children = newValue
            for x in _children {
                x._parent = self
            }
        }
    }

    internal var _children: [DOMNode] = []

    public func appendChild(_ child: DOMNode) {
        _children.append(child)
        child._parent = self
    }

    public func insertChild(_ child: DOMNode, at index: Int) {
        _children.insert(child, at: index)
        child._parent = self
    }

    internal func _removeChild(_ child: DOMNode) {
        _children.removeAll { $0 === child }
        child._parent = nil
    }

    public func index(of child: DOMNode) -> Int? {
        _children.firstIndex { $0 === child }
    }
}
