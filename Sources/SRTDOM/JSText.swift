import SRTCore
import JavaScriptKitShim

public final class JSText: JSNode {
    public override init(jsObject: JSObject) {
        super.init(jsObject: jsObject)
    }

    public var data: String {
        get {
            .construct(from: jsValue.data)!
        }
        set {
            jsObject.data = newValue.jsValue
        }
    }

    package override func print(to p: PrettyPrinter) {
        p.write(data)
    }
}
