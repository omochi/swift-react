import Collections
import SRTCore
import ReactInterface
import DOMModule

public final class VNode: Hashable {
    public struct Equality: Hashable {
        var componentType: ObjectIdentifier
        var tagName: String?
        var idType: ObjectIdentifier?
        var idValue: AnyHashable?

        init(ghost: Ghost) {
            self.init(
                component: ghost.component,
                id: ghost.id
            )
        }

        init(
            component: any Component,
            id: (any Hashable)?
        ) {
            self.componentType = ObjectIdentifier(type(of: component))

            if let tag = component as? TagElement {
                self.tagName = tag.tagName
            } else {
                self.tagName = nil
            }

            if let id {
                self.idType = ObjectIdentifier(type(of: id))
                self.idValue = AnyHashable(id)
            } else {
                self.idType = nil
                self.idValue = nil
            }
        }
    }

    public init(
        ghost: Ghost
    ) {
        self.ghost = ghost
        self.equality = Equality(ghost: ghost)
    }

    public let ghost: Ghost
    public let equality: Equality
    public var dom: DOMTagNode?

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
        _ attributes: TagAttributes = .init(),
        _ children: [Node] = []
    ) -> VNode {
        let tag = TagElement(
            tagName: name,
            attributes: attributes,
            children: children
        )
        return component(tag)
    }

    public static func component<C: Component>(_ component: C) -> VNode {
        let input = GhostInput(component: component)
        let ghost = C._extractGhost(input)
        return VNode(ghost: ghost)
    }
}
