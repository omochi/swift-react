public class JSThrowingFunction {
    private let base: JSFunction

    public init(_ base: JSFunction) {
        self.base = base
    }

    public func callAsFunction(this: JSObject? = nil, arguments: [any ConvertibleToJSValue]) throws -> JSValue {
        base(this: this, arguments: arguments)
    }

    @discardableResult
    public func callAsFunction(this: JSObject? = nil, _ arguments: (any ConvertibleToJSValue)...) throws -> JSValue {
        try self(this: this, arguments: arguments)
    }

    public func new(arguments: [any ConvertibleToJSValue]) throws -> JSObject {
        base.new(arguments: arguments)
    }

    public func new(_ arguments: (any ConvertibleToJSValue)...) throws -> JSObject {
        try new(arguments: arguments)
    }

    public var jsValue: JSValue { .function(base) }
}
