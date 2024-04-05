import Algorithms
import SRTCore
import JavaScriptKitShim

public struct JSHTMLElement: ConstructibleFromJSValue & CustomStringConvertible {
    public init(jsObject: JSObject) {
        self.jsObject = jsObject
    }

    public static func construct(from value: JSValue) -> Self? {
        value.object.map(Self.init(jsObject:))
    }

    public let jsObject: JSObject
    public var jsValue: JSValue { .object(jsObject) }

    public func asNode() -> JSNode { JSNode(jsObject: jsObject) }

    public var tagName: String {
        .construct(from: jsValue.tagName)!
    }

    public func getAttribute(_ name: String) throws -> String? {
        String?.construct(from: try jsValue.throws.getAttribute(name))!
    }

    public func getAttributeNames() throws -> [String] {
        [String].construct(from: try jsValue.throws.getAttributeNames())!
    }

    public func setAttribute(_ name: String, _ value: String) throws {
        _ = try jsValue.throws.setAttribute(name, value)
    }

    public func removeAttribute(_ name: String) throws {
        _ = try jsValue.throws.removeAttribute(name)
    }

    public var description: String {
        asNode().description
    }

    private func writeAttributes(to p: PrettyPrinter) throws {
        let q = "\""

        for k in try getAttributeNames() {
            let v = try getAttribute(k)!
            p.write(space: " ", "\(k)=\(q)\(v)\(q)")
        }
    }

    package func write(to p: PrettyPrinter) throws {
        let tagName = self.tagName.lowercased()
        
        let children = asNode().childNodes.compacted()
        if children.isEmpty {
            p.write("<" + tagName)
            try writeAttributes(to: p)
            p.write(" />")
            return
        }

        p.write("<" + tagName)
        try writeAttributes(to: p)
        p.write(">")
        p.nest {
            for x in children {
                x.write(to: p)
                p.writeNewline()
            }
        }
        p.write("</" + tagName + ">")
    }
}
