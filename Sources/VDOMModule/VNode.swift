import Collections
import SRTCore
import ReactInterface
import DOMModule

public final class VNode {
    public struct EQToken: Hashable {
        var type: Any.Type
        var id: AnyHashable

        var value: (ObjectIdentifier, AnyHashable) {
            (ObjectIdentifier(type), id)
        }

        init(component: any Component) {
            self.type = Swift.type(of: component)
            self.id = component.anyID
        }

        public static func ==(a: Self, b: Self) -> Bool { a.value == b.value }

        public func hash(into hasher: inout Hasher) {
            let value = self.value
            hasher.combine(value.0)
            hasher.combine(value.1)
        }
    }

    public init(
        component: any Component
    ) {
        self.component = component
    }

    public var eqToken: EQToken {
        return EQToken(component: component)
    }

    public func isEqual(to other: VNode) -> Bool { eqToken == other.eqToken }

    public let component: any Component
    public var dom: DOMTagNode?

    public var parent: VNode? { _parent }

    public func removeFromParent() {
        _parent?._removeChild(self)
    }

    internal weak var _parent: VNode?

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

    public static func unknownNode(_ node: VNode) -> any Error {
        MessageError("unknown VNode: \(type(of: node))")
    }

    public static func tag(
        _ name: String,
        _ attributes: TagAttributes = [:],
        _ children: [Node] = []
    ) -> VNode {
        VNode(
            component: TagElement(
                tagName: name,
                attributes: attributes,
                children: children
            )
        )
    }
}
