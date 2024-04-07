import SRTJavaScriptKitEx

public struct DOMEventListener: Hashable & ConvertibleToJSFunction & ConstructibleFromJSValue {
    public init(jsFunction: JSFunction) {
        self.jsFunction = jsFunction
    }

    public var jsFunction: JSFunction

    public static func construct(from value: JSValue) -> DOMEventListener? {
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

public typealias DOMEventListeners = [String: JSFunction]
