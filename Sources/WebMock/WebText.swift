import SRTCore
import JavaScriptKitMock

public final class WebText: WebNode {
    public init(_ string: String) {
        self.data = string
    }
    
    public var data: String

    internal override func print(to p: PrettyPrinter) {
        p.write(data)
    }

    public override func _get_property(_ name: String) -> JSValue {
        switch name {
        case "data": data.jsValue
        default: super._get_property(name)
        }
    }
}
