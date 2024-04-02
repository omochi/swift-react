import Algorithms
import SRTCore
import JavaScriptKitShim

public struct JSHTMLElement: CustomStringConvertible {
    public init(jsObject: JSObject) {
        self.jsObject = jsObject
    }

    public let jsObject: JSObject
    public var jsValue: JSValue { .object(jsObject) }

    public func asNode() -> JSNode { JSNode(jsObject: jsObject) }

    public var tagName: String {
        .construct(from: jsValue.tagName)!
    }

    public func getAttribute(_ name: String) -> String? {
        .construct(from: jsValue.getAttribute(name))
    }

    public func getAttributeNames() -> [String] {
        .construct(from: jsValue.getAttributeNames())!
    }

    public func setAttribute(_ name: String, _ value: String) {
        jsValue.setAttribute(name, value)
    }

    public func removeAttribute(_ name: String) {
        jsValue.removeAttribute(name)
    }

    public var description: String {
        asNode().description
    }

    private func printAttributes(to p: PrettyPrinter) {
        let q = "\""

        for k in getAttributeNames() {
            let v = getAttribute(k)!
            p.write(space: " ", "\(k)=\(q)\(v)\(q)")
        }
    }

    package func print(to p: PrettyPrinter) {
        let children = asNode().childNodes.compacted()
        if children.isEmpty {
            p.write("<" + tagName)
            printAttributes(to: p)
            p.write(" />")
            return
        }

        p.write("<" + tagName)
        printAttributes(to: p)
        p.write(">")
        p.nest {
            for x in children {
                x.print(to: p)
                p.writeNewline()
            }
        }
        p.write("</" + tagName + ">")
    }
}
