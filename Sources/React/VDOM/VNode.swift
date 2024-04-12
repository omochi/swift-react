import SRTCore
import SRTDOM

package final class VNode: Hashable {
    public struct Equality: Hashable {
        var componentType: ObjectIdentifier
        var tagName: String?
        var key: AnyHashable?

        init(ghost: Ghost) {
            let component = ghost.component

            self.componentType = ObjectIdentifier(type(of: component))

            if let tag = ghost.component as? TagElement {
                self.tagName = tag.tagName
            } else {
                self.tagName = nil
            }

            self.key = component.key
        }
    }

    public final class ListenerBridge {
        public init() {}

        public var js: JSEventListener?
        public var swift: EventListener?
    }

    public init(
        ghost: Ghost
    ) {
        self.ghost = ghost
        self.equality = Equality(ghost: ghost)
    }

    public let ghost: Ghost
    public let equality: Equality

    internal weak var _parent: VNode?
    private var _children: [VNode] = []

    public var new: VNode??
    public var dom: JSNode?
    public var listeners: [String: ListenerBridge] = [:]
    public var contextValueHolder: ContextValueHolder?
    private var isDirty: Bool = false

    public static func ==(a: VNode, b: VNode) -> Bool {
        a.equality == b.equality
    }

    public func hash(into hasher: inout Hasher) {
        hasher.combine(equality)
    }

    public func markDirty() {
        isDirty = true
    }

    public func consumeDirty() -> Bool {
        defer { isDirty = false }
        return isDirty
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

    package static func tag(
        _ name: String,
        _ attributes: Attributes = [:],
        _ children: [Node] = []
    ) -> VNode {
        let tag = TagElement(
            tagName: name,
            attributes: attributes,
            children: children
        )
        return component(tag)
    }

    package static func component<C: Component>(_ component: C) -> VNode {
        let input = GhostInput(component: component)
        let ghost = C._extractGhost(input)
        return VNode(ghost: ghost)
    }
}
