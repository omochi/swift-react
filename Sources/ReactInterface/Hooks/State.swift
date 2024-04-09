@propertyWrapper
public struct State<Value> {
    public init(wrappedValue: Value) {
        self.storage = Storage()
    }

    public var wrappedValue: Value {
        get {
            guard let value = storage.value else {
                fatalError("State is uninitialized")
            }
            return value
        }
        set {
            storage.value = newValue
            storage.didUpdate?()
        }
    }

    package var storage: Storage

    package final class Storage {
        init() {}

        var value: Value?
        
        var didUpdate: (() -> Void)?
    }
}
