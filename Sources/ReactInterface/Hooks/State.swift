@propertyWrapper
public struct State<Value: Equatable>: _AnyState {
    public init(wrappedValue: Value) {
        self.storage = Storage()

        storage.value = wrappedValue
    }

    public init() where Value: ExpressibleByNilLiteral {
        self.init(wrappedValue: nil)
    }

    public var wrappedValue: Value {
        get { storage.getValue() }
        nonmutating set { storage.setValue(newValue) }
    }

    package var storage: Storage

    package var _anyStateStorage: any _AnyStateStorage { storage }
    package var _anyHookObject: any _AnyHookObject { _anyStateStorage }

    package final class Storage: _AnyStateStorage {
        init() {}

        var value: Value?
        var isDirty: Bool = false
        var didChange: (() -> Void)?

        func getValue() -> Value {
            guard let value else {
                preconditionFailure("State is uninitialized")
            }
            return value
        }

        func setValue(_ newValue: Value) {
            if value == newValue { return }
            
            value = newValue
            isDirty = true
            didChange?()
        }

        package func _consumeDirty() -> Bool {
            defer { isDirty = false }
            return isDirty
        }

        package func _setDidChange(_ newValue: (() -> Void)?) {
            didChange = newValue
        }

        package func _take(fromAnyHookObject object: any _AnyHookObject) {
            guard let o = object as? Storage else { return }

            value = o.value
            isDirty = isDirty || o.isDirty
            didChange = o.didChange
        }
    }
}

package protocol _AnyState: _AnyHookWrapper {
    var _anyStateStorage: any _AnyStateStorage { get }
}

package protocol _AnyStateStorage: _AnyHookObject {
    func _consumeDirty() -> Bool
    func _setDidChange(_ newValue: (() -> Void)?)
}

