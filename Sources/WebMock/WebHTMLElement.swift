import SRTCore
import JavaScriptKitMock

public final class WebHTMLElement: WebNode {
    public init(
        _ tagName: String
    ) {
        self.tagName = tagName
    }

    public let tagName: String

    private var _attributes: [String: String] = [:]

    public func getAttribute(_ name: String) -> String? {
        _attributes[name]
    }

    public func getAttributeNames() -> [String] {
        Array(_attributes.keys)
    }

    public func setAttribute(_ name: String, _ value: String) {
        _attributes[name] = value
    }

    public func remove() {
        parentNode?.removeChild(self)
    }

    public func removeAttribute(_ name: String) {
        _attributes[name] = nil
    }

    private func printAttributes(to p: PrettyPrinter) {
        let q = "\""

        for k in _attributes.keys {
            let v = _attributes[k]!
            p.write(space: " ", "\(k)=\(q)\(v)\(q)")
        }
    }

    internal override func print(to p: PrettyPrinter) {
        if childNodes.isEmpty {
            p.write("<" + tagName)
            printAttributes(to: p)
            p.write(" />")
            return
        }

        p.write("<" + tagName)
        printAttributes(to: p)
        p.write(">")
        p.nest {
            for x in childNodes {
                x.print(to: p)
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
        case "remove": JSFunction(Self.remove).jsValue
        case "removeAttribute": JSFunction(Self.remove).jsValue
        default: super._get_property(name)
        }
    }
}
