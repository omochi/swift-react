@propertyWrapper
public struct State<Value>: _AnyState {
    public init(wrappedValue: Value) {
        self.storage = Storage()

        storage.value = wrappedValue
    }

    public init() where Value: ExpressibleByNilLiteral {
        self.init(wrappedValue: nil)
    }

    public var wrappedValue: Value {
        get { storage.getValue() }
        set { storage.setValue(newValue) }
    }

    package var storage: Storage

    package var _anyStateStorage: any _AnyStateStorage { storage }

    package final class Storage: _AnyStateStorage {
        init() {}

        var value: Value?
        var isDirty: Bool = false
        var didUpdate: (() -> Void)?

        func getValue() -> Value {
            guard let value else {
                fatalError("State is uninitialized")
            }
            return value
        }

        func setValue(_ newValue: Value) {
            value = newValue
            isDirty = true
            didUpdate?()
        }

        func take(_ o: Storage) {
            value = o.value
            isDirty = isDirty || o.isDirty
            didUpdate = o.didUpdate
        }

        package func _takeAny(_ other: any _AnyStateStorage) {
            guard let other = other as? Storage else { return }
            take(other)
        }

        package func _consumeDirty() -> Bool {
            defer { isDirty = false }
            return isDirty
        }

        package func _setDidUpdate(_ newValue: (() -> Void)?) {
            didUpdate = newValue
        }
    }
}

package protocol _AnyState {
    var _anyStateStorage: any _AnyStateStorage { get }
}

package protocol _AnyStateStorage: AnyObject {
    func _takeAny(_ other: any _AnyStateStorage)
    func _consumeDirty() -> Bool
    func _setDidUpdate(_ newValue: (() -> Void)?)
}

