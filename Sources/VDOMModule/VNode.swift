import Collections
import SRTCore
import ReactInterface
import DOMModule

public class VNode {
    public struct EQToken: Hashable {
        enum Payload: Hashable {
            case tag(String)
            case component(type: ObjectIdentifier, id: AnyHashable)
        }

        var payload: Payload

        public static func tag(name: String) -> EQToken {
            return EQToken(payload: .tag(name))
        }

        public static func component(type: any ReactComponent.Type, id: any Hashable) -> EQToken {
            return EQToken(
                payload: .component(
                    type: ObjectIdentifier(type),
                    id: AnyHashable(id)
                )
            )
        }
    }

    internal init() {
    }

    public var eqToken: EQToken { fatalError("unimplemented") }

    public func isEqual(to other: VNode) -> Bool { eqToken == other.eqToken }

    public var parent: VParentNode? { _parent }

    public func removeFromParent() {
        _parent?._removeChild(self)
    }

    internal weak var _parent: VParentNode?

    public static func unknownNode(_ node: VNode) -> any Error {
        MessageError("unknown VNode: \(type(of: node))")
    }
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

    public override var eqToken: VNode.EQToken {
        .tag(name: tagName)
    }

    public var tagName: String
    public var attributes: VAttributes

    public var dom: DOMTagNode?
}

public final class VComponentNode: VParentNode {
    public init(
        component: any ReactComponent
    ) {
        self.component = component

        super.init()
    }

    public override var eqToken: VNode.EQToken {
        return .component(
            type: type(of: component),
            id: component.id
        )
    }

    public var component: any ReactComponent
}
