import SRTCore

@propertyWrapper
public struct Context<Value: ContextValue>: _AnyHookWrapper {
    public init() {}

    public var wrappedValue: Value {
        object.value
    }

    private let _object: Box<Object?> = Box()

    var object: Object { _object.value! }

    func prepare(object: Object?) {
        _object.value = object ?? Object()
    }

    final class Object: _AnyContextHookObject {
        init() {}

        var valueType: any ContextValue.Type { Value.self }
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

protocol _AnyContextHookObject: AnyObject {
    var valueType: any ContextValue.Type { get }
    var holder: ContextValueHolder? { get set }
    var disposable: (any Disposable)? { get set }
}
