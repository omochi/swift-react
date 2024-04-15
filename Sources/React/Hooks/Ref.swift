import SRTCore

@propertyWrapper
public struct Ref<Value>: _AnyRef {
    public init() {}

    typealias Object = RefObject<Value>

    func prepare(object: Object?) {
        self.object = object ?? Object()
    }

    private let _object: Box<Object?> = Box()

    var object: Object {
        get { _object.value! }
        nonmutating set { _object.value = newValue }
    }

    public var wrappedValue: Value? {
        get {
            object.value
        }
        nonmutating set {
            object.value = newValue
        }
    }

    public var projectedValue: RefObject<Value> {
        object
    }
}

protocol _AnyRef: _AnyHookWrapper {
}

public final class RefObject<Value>: IdentityHashable {
    public init() {}

    public var value: Value?
}
