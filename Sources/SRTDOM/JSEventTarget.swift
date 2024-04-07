import SRTJavaScriptKitEx

public protocol JSEventTargetProtocol: ConvertibleToJSObject {
    func addEventListener(_ type: String, _ listener: DOMEventListener) throws
    func removeEventListener(_ type: String, _ listener: DOMEventListener) throws
    func dispatchEvent(_ event: any JSEventProtocol) throws
}

extension JSEventTargetProtocol {
    public func addEventListener(_ type: String, _ listener: DOMEventListener) throws {
        _ = try jsValue.throws.addEventListener(type, listener)
    }

    public func removeEventListener(_ type: String, _ listener: DOMEventListener) throws {
        _ = try jsValue.throws.removeEventListener(type, listener)
    }

    public func dispatchEvent(_ event: any JSEventProtocol) throws {
        _ = try jsValue.throws.dispatchEvent(event.jsValue)
    }
}

public struct JSEventTarget: JSEventTargetProtocol {
    public init(jsObject: JSObject) {
        self.jsObject = jsObject
    }

    public static func construct(from value: JSValue) -> Self? {
        value.object.map(Self.init)
    }

    public var jsObject: JSObject
}
