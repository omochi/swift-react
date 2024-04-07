import SRTCore
import JavaScriptKitShim

extension ConstructibleFromJSValue {
    public static func mustConstruct(from jsValue: JSValue) throws -> Self {
        guard let value = construct(from: jsValue) else {
            throw MessageError("failed to construct \(Self.self), value was \(jsValue)")
        }
        return value
    }

    public static func mustConstruct(from arguments: [JSValue], at index: Int) throws -> Self {
        let value = try arguments[safe: index].unwrap("arguments[\(index)]")
        return try Self.mustConstruct(from: value)
    }

    public static func unsafeConstruct(from jsValue: JSValue) -> Self {
        try! mustConstruct(from: jsValue)
    }

    public static func unsafeConstruct(from arguments: [JSValue], at index: Int) -> Self {
        try! mustConstruct(from: arguments, at: index)
    }
}
