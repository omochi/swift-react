import SRTCore
import JavaScriptKitMock

public final class WebHTMLElement: WebNode {
    public final class Constructor: JSNativeObject {
        internal init() {}

        public var jsValue: JSValue { .function(JSFunction(native: self)) }

        public static let shared = Constructor()
    }

    public init(
        _ tagName: String
    ) {
        self.tagName = tagName.uppercased()
    }

    public let tagName: String

    private var _attributes: [String: String] = [:]

    public func getAttribute(_ name: String) -> String? {
        _attributes[name]
    }

    public func getAttributeNames() -> [String] {
        _attributes.keys.sorted()
    }

    public func setAttribute(_ name: String, _ value: String) {
        _attributes[name] = value
    }

    public func removeAttribute(_ name: String) {
        _attributes[name] = nil
    }

    private func writeAttributes(to p: PrettyPrinter) {
        let q = "\""

        for k in getAttributeNames() {
            let v = getAttribute(k)!
            p.write(space: " ", "\(k)=\(q)\(v)\(q)")
        }
    }

    internal override func write(to p: PrettyPrinter) {
        let tagName = self.tagName.lowercased()

        if childNodes.isEmpty {
            p.write("<" + tagName)
            writeAttributes(to: p)
            p.write(" />")
            return
        }

        p.write("<" + tagName)
        writeAttributes(to: p)
        p.write(">")
        p.nest {
            for x in childNodes {
                x.write(to: p)
                p.writeNewline()
            }
        }
        p.write("</" + tagName + ">")
    }

    public override func _get_property(_ name: String) -> JSValue {
        switch name {
        case "tagName": tagName.jsValue
        case "getAttribute": JSFunction(Self.getAttribute).jsValue
        case "getAttributeNames": JSFunction(Self.getAttributeNames).jsValue
        case "setAttribute": JSFunction(Self.setAttribute).jsValue
        case "removeAttribute": JSFunction(Self.remove).jsValue
        default: super._get_property(name)
        }
    }

    public override func _isInstanceOf(_ constructor: JSFunction) -> Bool {
        if constructor.native === Constructor.shared {
            return true
        }
        return super._isInstanceOf(constructor)
    }
}
