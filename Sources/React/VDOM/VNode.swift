import SRTCore
import SRTDOM

package final class VNode: Hashable {
    public struct Equality: Hashable {
        enum Kind: Hashable {
            case tag(String)
            case component(ObjectIdentifier)
        }

        var kind: Kind
        var key: AnyHashable?

        init(component: any Component) {
            self.kind = if let tag = component as? HTMLElement {
                .tag(tag.tagName)
            } else {
                .component(ObjectIdentifier(type(of: component)))
            }

            self.key = component.key
        }
    }

    public init(
        component: any Component
    ) {
        self.component = component
        self.equality = Equality(component: component)
    }

    public let component: any Component
    public let equality: Equality

    internal var instance: Instance? {
        get { _instance }
        set {
            _instance = newValue
            newValue?.owner = self
        }
    }

    private var _instance: Instance?

    internal weak var _parent: VNode?
    private var _children: [VNode] = []

    public static func ==(a: VNode, b: VNode) -> Bool {
        a.equality == b.equality
    }

    public func hash(into hasher: inout Hasher) {
        hasher.combine(equality)
    }

    public var parent: VNode? { _parent }

    public func removeFromParent() {
        _parent?._removeChild(self)
    }

    public var children: [VNode] {
        get { _children }
        set {
            for x in _children {
                x._parent = nil
            }
            _children = newValue
            for x in _children {
                x._parent = self
            }
        }
    }

    public func appendChild(_ child: VNode) {
        _children.append(child)
        child._parent = self
    }

    public func replaceChild(_ newChild: VNode, at index: Int) {
        let oldChild = _children[index]
        _children[index] = newChild
        oldChild._parent = nil
        newChild._parent = self
    }

    public func appendChildren(_ children: [VNode]) {
        for x in children {
            appendChild(x)
        }
    }

    internal func _removeChild(_ child: VNode) {
        _children.removeAll { $0 === child }
        child._parent = nil
    }

    public func index(of child: VNode) -> Int? {
        _children.firstIndex { $0 === child }
    }

    public func isDescendant(of ancestor: VNode) -> Bool {
        var nodeO: VNode? = self.parent
        while true {
            guard let node = nodeO else { return false }
            if node === ancestor { return true }
            nodeO = node.parent
        }
    }

    public static func unknownNode(_ node: VNode) -> any Error {
        MessageError("unknown VNode: \(type(of: node))")
    }
}
