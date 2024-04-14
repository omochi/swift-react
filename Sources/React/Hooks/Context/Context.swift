@propertyWrapper
public final class Context<Value: ContextValue>: _AnyContextHook {
    public init() {}

    public var wrappedValue: Value {
        object!.value
    }

    var object: Object?

    func prepare(object: Object?) {
        self.object = object ?? Object()
    }

    var valueType: any ContextValue.Type { Value.self }

    func setHolder(_ holder: ContextValueHolder?, disposable: (any Disposable)?) {
        object!.holder = holder
        object!.disposable = disposable
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
