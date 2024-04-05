import JavaScriptKitMock

extension JSValue {
    public subscript(dynamicMember name: String) -> (((any ConvertibleToJSValue)...) -> JSValue) {
        let obj: JSObject = self.object!
        let value: JSValue = obj[name]
        let fn: JSFunction = value.function!
        return { (arguments: (any ConvertibleToJSValue)...) in
            fn(this: obj, arguments: arguments)
        }
    }
}
