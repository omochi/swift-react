import SRTCore

@propertyWrapper
public final class Ref<Value>: _AnyRef {
    public init() {}

    typealias Object = RefObject<Value>

    func prepare(object: Object?) {
        self.object = object ?? Object()
    }

    var object: Object?

    public var wrappedValue: Value? {
        get {
            object!.value
        }
        set {
            object!.value = newValue
        }
    }

    public var projectedValue: RefObject<Value> {
        object!
    }
}

protocol _AnyRef: _AnyHookWrapper {
}

public final class RefObject<Value>: IdentityHashable {
    public init() {}

    public var value: Value?
}
