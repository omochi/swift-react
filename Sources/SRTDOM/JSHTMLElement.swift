import Algorithms
import SRTCore
import SRTJavaScriptKitEx

public protocol JSHTMLElementProtocol: JSNodeProtocol {
    var tagName: String { get }
    func click() throws
    func getAttribute(_ name: String) throws -> String?
    func getAttributeNames() throws -> [String]
    func setAttribute(_ name: String, _ value: String) throws
    func removeAttribute(_ name: String) throws
}

extension JSHTMLElementProtocol {
    public var tagName: String {
        .unsafeConstruct(from: jsValue.tagName)
    }

    public func click() throws {
        _ = try jsValue.throws.click()
    }

    public func getAttribute(_ name: String) throws -> String? {
        try .mustConstruct(from: try jsValue.throws.getAttribute(name))
    }

    public func getAttributeNames() throws -> [String] {
        try .mustConstruct(from: try jsValue.throws.getAttributeNames())
    }

    public func setAttribute(_ name: String, _ value: String) throws {
        _ = try jsValue.throws.setAttribute(name, value)
    }

    public func removeAttribute(_ name: String) throws {
        _ = try jsValue.throws.removeAttribute(name)
    }
}

public struct JSHTMLElement: JSHTMLElementProtocol & ConstructibleFromJSValue {
    public init(jsObject: JSObject) {
        self.jsObject = jsObject
    }

    public static func construct(from value: JSValue) -> Self? {
        value.object.map(Self.init)
    }

    public var jsObject: JSObject

    public func asNode() -> JSNode { JSNode(jsObject: jsObject) }

    private func writeAttributes(to p: PrettyPrinter) throws {
        let q = "\""

        for k in try getAttributeNames() {
            let v = try getAttribute(k).unwrap("attribute \(k)")
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
