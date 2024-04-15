import SRTCore

@propertyWrapper
public struct Context<Value: ContextValue>: _AnyContextHook {
    public init() {}

    public var wrappedValue: Value {
        object.value
    }

    private let _object: Box<Object?> = Box()

    var object: Object { _object.value! }

    func prepare(object: Object?) {
        _object.value = object ?? Object()
    }

    var valueType: any ContextValue.Type { Value.self }

    func setHolder(_ holder: ContextValueHolder?, disposable: (any Disposable)?) {
        object.holder = holder
        object.disposable = disposable
    }

    final class Object {
        init() {}

        var disposable: (any Disposable)?
        weak var holder: ContextValueHolder?

        var value: Value {
            guard let holder,
                  let value = holder.value as? Value else {
                return .defaultValue
            }
            return value
        }
    }
}

protocol _AnyContextHook: _AnyHookWrapper {
    var valueType: any ContextValue.Type { get }
    func setHolder(_ holder: ContextValueHolder?, disposable: (any Disposable)?)
}
