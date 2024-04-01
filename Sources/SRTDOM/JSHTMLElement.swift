import Algorithms
import SRTCore
import JavaScriptKitShim

public final class JSHTMLElement: JSNode {
    public override init(jsObject: JSObject) {
        super.init(jsObject: jsObject)
    }

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

    private func printAttributes(to p: PrettyPrinter) {
        let q = "\""

        for k in getAttributeNames() {
            let v = getAttribute(k)!
            p.write(space: " ", "\(k)=\(q)\(v)\(q)")
        }
    }

    package override func print(to p: PrettyPrinter) {
        let children = childNodes.compacted()
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
