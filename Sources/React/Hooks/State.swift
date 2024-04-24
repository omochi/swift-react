import SRTCore

@propertyWrapper
public struct State<Value: Equatable>: _AnyHookWrapper {
    public init(wrappedValue: Value) {
        self.initialValue = wrappedValue
    }

    public var wrappedValue: Value {
        get { object.getValue() }
        nonmutating set { object.setValue(newValue) }
    }

    private var initialValue: Value

    private let _object: Box<Object?> = Box()

    var object: Object { _object.value! }

    func prepare(object: Object?) {
        _object.value = object ?? Object(value: initialValue)
    }

    final class Object: _AnyStateHookObject {
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
    public init() {
        self.init(wrappedValue: nil)
    }
}

protocol _AnyStateHookObject: AnyObject {
    var didChange: (() -> Void)? { get set }
}
