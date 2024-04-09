import SRTJavaScriptKitEx

public struct JSEventListener: Hashable & ConvertibleToJSFunction & ConstructibleFromJSValue {
    public init(jsFunction: JSFunction) {
        self.jsFunction = jsFunction
    }

    public var jsFunction: JSFunction

    public static func construct(from value: JSValue) -> JSEventListener? {
        value.function.map(Self.init)
    }

    public init(_ impl: @escaping (JSEvent) -> Void) {
        let cl = JSClosure { (args) in
            let ev: JSEvent = .unsafeConstruct(from: args, at: 0)
            impl(ev)
            return .undefined
        }
        self.init(jsFunction: cl)
    }
}

public typealias JSEventListeners = [String: JSEventListener]
