import SRTCore
import JavaScriptKitShim

public struct JSText {
    public init(jsObject: JSObject) {
        self.jsObject = jsObject
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
