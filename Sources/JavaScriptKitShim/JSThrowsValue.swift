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
        let obj: JSObject = value.object!
        let tobj: JSThrowingObject = obj.throwing
        let fn: ((any ConvertibleToJSValue)...) throws -> JSValue = tobj[name]!
        return fn
    }
}
