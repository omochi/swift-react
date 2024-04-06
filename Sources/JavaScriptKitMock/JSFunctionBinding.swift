import SRTCore

private func castThis<T>(_ this: JSObject?, _ type: T.Type) throws -> T {
    let this = try this.unwrap("this")
    return try this.castNative(to: type)
}

private func castArg<T: ConstructibleFromJSValue>(_ arguments: [JSValue], _ index: Int, _ type: T.Type) throws -> T {
    let value = try arguments[safe: index].unwrap("arguments[\(index)]")
    return try T._mustConstruct(from: value)
}

extension JSFunction {
    public convenience init<
        S: JSNativeObject
    >(
        _ selector: @escaping (S) -> () throws -> Void
    ) {
        func impl(this: JSObject?, arguments: [JSValue]) throws -> JSValue {
            let method = selector(try castThis(this, S.self))
            try method()
            return .undefined
        }
        self.init(impl: impl)
    }

    public convenience init<
        S: JSNativeObject,
        R: ConvertibleToJSValue
    >(
        _ selector: @escaping (S) -> () throws -> R
    ) {
        func impl(this: JSObject?, arguments: [JSValue]) throws -> JSValue {
            let method = selector(try castThis(this, S.self))
            return try method().jsValue
        }
        self.init(impl: impl)
    }


    public convenience init<
        S: JSNativeObject,
        A0: ConstructibleFromJSValue
    >(
        _ selector: @escaping (S) -> (A0) throws -> Void
    ) {
        func impl(this: JSObject?, arguments: [JSValue]) throws -> JSValue {
            let method = selector(try castThis(this, S.self))
            let a0 = try castArg(arguments, 0, A0.self)
            try method(a0)
            return .undefined
        }
        self.init(impl: impl)
    }

    public convenience init<
        S: JSNativeObject,
        A0: ConstructibleFromJSValue,
        R: ConvertibleToJSValue
    >(
        _ selector: @escaping (S) -> (A0) throws -> R
    ) {
        func impl(this: JSObject?, arguments: [JSValue]) throws -> JSValue {
            let method = selector(try castThis(this, S.self))
            let a0 = try castArg(arguments, 0, A0.self)
            return try method(a0).jsValue
        }
        self.init(impl: impl)
    }

    public convenience init<
        S: JSNativeObject,
        A0: ConstructibleFromJSValue,
        A1: ConstructibleFromJSValue
    >(
        _ selector: @escaping (S) -> (A0, A1) throws -> Void
    ) {
        func impl(this: JSObject?, arguments: [JSValue]) throws -> JSValue {
            let method = selector(try castThis(this, S.self))
            let a0 = try castArg(arguments, 0, A0.self)
            let a1 = try castArg(arguments, 1, A1.self)
            try method(a0, a1)
            return .undefined
        }
        self.init(impl: impl)
    }

    public convenience init<
        S: JSNativeObject,
        A0: ConstructibleFromJSValue,
        A1: ConstructibleFromJSValue,
        R: ConvertibleToJSValue
    >(
        _ selector: @escaping (S) -> (A0, A1) throws -> R
    ) {
        func impl(this: JSObject?, arguments: [JSValue]) throws -> JSValue {
            let method = selector(try castThis(this, S.self))
            let a0 = try castArg(arguments, 0, A0.self)
            let a1 = try castArg(arguments, 1, A1.self)
            return try method(a0, a1).jsValue
        }
        self.init(impl: impl)
    }
}
