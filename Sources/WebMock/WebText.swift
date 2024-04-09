import SRTCore
import JavaScriptKitMock

public final class WebText: WebNode {
    public final class Constructor: JSNativeObject {
        internal init() {}

        public var jsValue: JSValue { .function(JSFunction(native: self)) }

        public static let shared = Constructor()
    }

    public init(_ string: String) {
        self.data = string
    }
    
    public var data: String

    internal override func write(to p: PrettyPrinter) {
        p.write(data)
    }

    public override func _get_property(_ name: String) -> JSValue {
        switch name {
        case "data": data.jsValue
        default: super._get_property(name)
        }
    }

    public override func _set_property(_ name: String, _ value: JSValue) {
        switch name {
        case "data": data = ._unsafeConstruct(from: value)
        default: super._set_property(name, value)
        }
    }

    public override func _isInstanceOf(_ constructor: JSFunction) -> Bool {
        if constructor.native === Constructor.shared {
            return true
        }
        return super._isInstanceOf(constructor)
    }
}
