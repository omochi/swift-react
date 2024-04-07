import SRTJavaScriptKitEx

public protocol JSEventProtocol: ConvertibleToJSObject {
    var type: String { get }
}

extension JSEventProtocol {
    public var type: String {
        .unsafeConstruct(from: jsValue.type)
    }
}

public struct JSEvent: JSEventProtocol {
    public init(jsObject: JSObject) {
        self.jsObject = jsObject
    }

    public static func construct(from value: JSValue) -> Self? {
        value.object.map(Self.init(jsObject:))
    }

    public let jsObject: JSObject
    public var jsValue: JSValue { .object(jsObject) }
}
