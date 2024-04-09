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
}

package protocol _AnyRef {
    var _anyRefObject: any _AnyRefObject { get }
}

public final class RefObject<Value>: _AnyRefObject {
    public init(_ value: Value?) {
        self.value = value
    }

    public var value: Value?

    public var _anyValue: Any? {
        get { value }
        set { value = newValue.flatMap { $0 as? Value } }
    }
}

package protocol _AnyRefObject: AnyObject {
    var _anyValue: Any? { get set }
}
