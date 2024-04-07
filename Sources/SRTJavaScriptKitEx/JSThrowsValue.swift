import SRTCore
import JavaScriptKitShim

extension JSValue {
    public var `throws`: JSThrowsValue {
        JSThrowsValue(self)
    }
}

@dynamicMemberLookup
public struct JSThrowsValue {
    public init(_ value: JSValue) {
        self.value = value
    }

    private var value: JSValue

    public subscript(dynamicMember name: String) -> ((any ConvertibleToJSValue)...) throws -> JSValue {
        guard let obj: JSObject = value.object else {
            return { (_: Any...) in throw NoneError("value.object") }
        }
        let tobj: JSThrowingObject = obj.throwing
        guard let fn: ((any ConvertibleToJSValue)...) throws -> JSValue = tobj[name] else {
            return { (_: Any...) in throw NoneError("value[\(name)]") }
        }
        return fn
    }
}
