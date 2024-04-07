import SRTJavaScriptKitEx

public protocol JSEventProtocol: ConvertibleToJSObject {
    func asEvent() -> JSEvent
    var type: String { get }
}

extension JSEventProtocol {
    public func asEvent() -> JSEvent {
        JSEvent(jsObject: jsObject)
    }

    public var type: String {
        .unsafeConstruct(from: jsValue.type)
    }
}

public struct JSEvent: JSEventProtocol & ConstructibleFromJSValue {
    public init(jsObject: JSObject) {
        self.jsObject = jsObject
    }

    public static func construct(from value: JSValue) -> Self? {
        value.object.map(Self.init)
    }

    public var jsObject: JSObject
}

public struct JSMouseEvent: JSEventProtocol & ConstructibleFromJSValue {
    public struct Constructor: ConvertibleToJSFunction & ConstructibleFromJSValue {
        public init(jsFunction: JSFunction) {
            self.jsFunction = jsFunction
        }

        public var jsFunction: JSFunction

        public static func construct(from value: JSValue) -> Self? {
            value.function.map(Self.init)
        }

        public func new(_ type: String) throws -> JSMouseEvent {
            try .mustConstruct(from: jsFunction.throws.new(type).jsValue)
        }
    }

    public init(jsObject: JSObject) {
        self.jsObject = jsObject
    }

    public var jsObject: JSObject

    public static func construct(from value: JSValue) -> JSMouseEvent? {
        value.object.map(Self.init)
    }
}
