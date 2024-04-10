import SRTCore

@propertyWrapper
public struct Ref<Value>: _AnyRef {
    public init(
        wrappedValue: Value? = nil
    ) {
        self.object = RefObject(wrappedValue)
    }

    private var object: RefObject<Value>

    public var wrappedValue: Value? {
        get {
            object.value
        }
        set {
            object.value = newValue
        }
    }

    public var projectedValue: RefObject<Value> {
        object
    }

    package var _anyRefObject: any _AnyRefObject { object }
    package var _anyHookObject: any _AnyHookObject { _anyRefObject }
}

package protocol _AnyRef: _AnyHookWrapper {
    var _anyRefObject: any _AnyRefObject { get }
}

public final class RefObject<Value>: IdentityHashable & _AnyRefObject {
    public init(_ value: Value?) {
        self.value = value
    }

    public var value: Value?

    package func _take(fromAnyHookObject object: any _AnyHookObject) {
        guard let o = object as? RefObject<Value> else { return }

        value = o.value
    }
}

package protocol _AnyRefObject: _AnyHookObject {

}
