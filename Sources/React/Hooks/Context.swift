public protocol ContextValue: Hashable {
    static var defaultValue: Self { get }
}

extension ContextValue {
    typealias Provider = ContextValueProvider<Self>
}

public struct ContextValueProvider<Value: ContextValue>: Component {
    public init(
        key: AnyHashable? = nil,
        value: Value,
        @ChildrenBuilder children: () -> [Node]
    ) {
        self.key = key
        self.value = value
        self.children = children()
    }

    public var key: AnyHashable?
    public var value: Value
    public var children: [Node]

    public var deps: AnyHashable? {
        AnyDeps(
            key,
            value,
            children.deps
        )
    }

    public func render() -> Node {
        children
    }

    public static func _extractGhost(_ input: GhostInput<Self>) -> Ghost {
        var ghost = extractGhostDefault(input)
        ghost.contextValue = (type: Value.self, value: input.component.value)
        return ghost
    }
}

package final class ContextValueHolder {
    public init(type: any ContextValue.Type) {
        self.emitter = Emitter()
        self.type = type
    }

    public let type: any ContextValue.Type
    private var _value: (any ContextValue)?
    public var emitter: Emitter<Void>

    public var value: any ContextValue {
        get { _value! }
        set {
            setValue(newValue)
        }
    }

    private func setValue<T: ContextValue>(_ value: T) {
        guard value != (_value as? T) else { return }
        emitter.emit(())
    }
}

public struct Context<Value: ContextValue>: _AnyHookWrapper {
    public init() {
        self.storage = Storage()
    }

    public var wrappedValue: Value {
        storage.value
    }

    package var storage: Storage

    package var _anyHookObject: any _AnyHookObject { storage }

    package final class Storage: _AnyContextStorage {
        public init() {}

        public var disposable: (any Disposable)?
        public weak var holder: ContextValueHolder?

        public var value: Value {
            guard let holder,
                  let value = holder.value as? Value else {
                return .defaultValue
            }
            return value
        }

        public var _valueType: any ContextValue.Type { Value.self }

        public func _setHolder(_ holder: ContextValueHolder?, disposable: (any Disposable)?) {
            self.holder = holder
            self.disposable = disposable
        }

        public func _take(fromAnyHookObject object: any _AnyHookObject) {
            guard let o = object as? Storage else { return }

            holder = o.holder
        }
    }
}

package protocol _AnyContextStorage: _AnyHookObject {
    var _valueType: any ContextValue.Type { get }
    func _setHolder(_ holder: ContextValueHolder?, disposable: (any Disposable)?)
}
