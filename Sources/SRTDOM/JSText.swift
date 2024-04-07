import SRTCore
import SRTJavaScriptKitEx

public protocol JSTextProtocol: JSNodeProtocol {
    var data: String { get set }
}

extension JSTextProtocol {
    public var data: String {
        get {
            .unsafeConstruct(from: jsValue.data)
        }
        nonmutating set {
            jsValue.data = newValue.jsValue
        }
    }
}

public struct JSText: JSTextProtocol & ConstructibleFromJSValue {
    public init(jsObject: JSObject) {
        self.jsObject = jsObject
    }

    public static func construct(from value: JSValue) -> Self? {
        value.object.map(Self.init)
    }

    public var jsObject: JSObject

    package func write(to p: PrettyPrinter) {
        p.write(data)
    }
}
