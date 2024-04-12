@propertyWrapper
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
