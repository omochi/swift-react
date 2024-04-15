@propertyWrapper
public final class State<Value: Equatable>: _AnyStateHook {
    public init(wrappedValue: Value) {
        self.initialValue = wrappedValue
    }

    public var wrappedValue: Value {
        get { object!.getValue() }
        set { object!.setValue(newValue) }
    }

    private var initialValue: Value

    var object: Object?

    func prepare(object: Object?) {
        self.object = object ?? Object(value: initialValue)
    }

    func setDidChange(_ newValue: (() -> Void)?) {
        object!.didChange = newValue
    }

    final class Object {
        init(value: Value) {
            self.value = value
        }

        private var value: Value
        var didChange: (() -> Void)?

        func getValue() -> Value { value }

        func setValue(_ newValue: Value) {
            if value == newValue { return }
            
            value = newValue
            didChange?()
        }
    }
}

extension State where Value: ExpressibleByNilLiteral {
    public convenience init() {
        self.init(wrappedValue: nil)
    }
}

protocol _AnyStateHook: _AnyHookWrapper {
    func setDidChange(_ newValue: (() -> Void)?)
}
