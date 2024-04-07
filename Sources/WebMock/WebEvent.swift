import JavaScriptKitMock

public class WebEvent: JSNativeObject {
    public init(_ type: String) {
        self.type = type
    }

    public let type: String

    public func _get_property(_ name: String) -> JSValue {
        switch name {
        case "type": type.jsValue
        default: .undefined
        }
    }
}

public class WebMouseEvent: WebEvent {
    public final class Constructor: JSNativeObject {
        internal init() {}

        public var jsValue: JSValue { .function(JSFunction(native: self)) }

        public func new(_ type: String) -> WebMouseEvent {
            WebMouseEvent(type)
        }

        public static let shared = Constructor()

        public func _new(arguments: [JSValue]) throws -> JSObject {
            let type: String = try ._mustConstruct(from: arguments, at: 0)
            return new(type).jsObject
        }
    }

    public override init(_ type: String) {
        super.init(type)
    }
}
