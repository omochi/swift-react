import SRTCore
@_exported import JavaScriptKitShim

extension ConstructibleFromJSValue {
    public static func mustConstruct(from jsValue: JSValue) throws -> Self {
        guard let value = construct(from: jsValue) else {
            throw MessageError("failed to construct \(Self.self), value was \(jsValue)")
        }
        return value
    }

    public static func unsafeConstruct(from jsValue: JSValue) -> Self {
        try! mustConstruct(from: jsValue)
    }
}
