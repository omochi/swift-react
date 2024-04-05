public class JSThrowingObject {
    private let base: JSObject
    public init(_ base: JSObject) {
        self.base = base
    }

    @_disfavoredOverload
    public subscript(_ name: String) -> (((any ConvertibleToJSValue)...) throws -> JSValue)? {
        let value: JSValue = base[name]
        guard let fn = value.function else { return nil }
        let tfn = fn.throws
        return { [base] (arguments: (any ConvertibleToJSValue)...) in
            try tfn(this: base, arguments: arguments)
        }
    }
}
