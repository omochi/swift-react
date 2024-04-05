import SRTCore
import JavaScriptKitShim

public struct JSText: ConstructibleFromJSValue {
    public init(jsObject: JSObject) {
        self.jsObject = jsObject
    }

    public static func construct(from value: JSValue) -> Self? {
        value.object.map(Self.init(jsObject:))
    }

    public let jsObject: JSObject
    public var jsValue: JSValue { .object(jsObject) }

    public func asNode() -> JSNode { JSNode(jsObject: jsObject) }

    public var data: String {
        get {
            .construct(from: jsValue.data)!
        }
        nonmutating set {
            jsObject.data = newValue.jsValue
        }
    }

    package func write(to p: PrettyPrinter) {
        p.write(data)
    }
}
