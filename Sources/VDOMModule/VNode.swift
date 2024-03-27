import Collections
import ReactInterface
import DOMModule

public class VNode {
    internal init() {
    }

    public var parent: VParentNode? { _parent }

    public func removeFromParent() {
        _parent?._removeChild(self)
    }

    internal weak var _parent: VParentNode?
}

public class VParentNode: VNode {
    public var children: [VNode] {
        get { _children }
        set {
            _children = newValue
            for x in _children {
                x._parent = self
            }
        }
    }

    private var _children: [VNode] = []

    public func appendChild(_ child: VNode) {
        _children.append(child)
        child._parent = self
    }

    internal func _removeChild(_ child: VNode) {
        _children.removeAll { $0 === child }
        child._parent = nil
    }
}

public typealias VAttributes = OrderedDictionary<String, String>

public final class VTagNode: VParentNode {
    public init(
        tagName: String,
        attributes: VAttributes = [:],
        children: [VNode] = []
    ) {
        self.tagName = tagName
        self.attributes = attributes
        
        super.init()

        for x in children {
            appendChild(x)
        }
    }

    public var tagName: String
    public var attributes: VAttributes

    public var dom: DOMNode?
}

public final class VComponentNode: VParentNode {
    public init(
        component: any ReactComponent
    ) {
        self.component = component

        super.init()
    }
    
    public var component: any ReactComponent
}
