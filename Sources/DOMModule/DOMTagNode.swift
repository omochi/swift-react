import Collections
import SRTCore

public final class DOMTagNode: DOMParentNode {
    public init(
        tagName: String,
        attributes: DOMAttributes = [:],
        children: [DOMNode] = []
    ) {
        self.tagName = tagName
        self.attributes = attributes

        super.init()

        for x in children {
            appendChild(x)
        }
    }

    public var tagName: String
    public var attributes: DOMAttributes


    private func printAttributes(to p: PrettyPrinter) {
        for (k, v) in attributes {
            let str = printAttributeValue(v)
            p.write(space: " ", "\(k)=\(str)")
        }
    }

    private func printAttributeValue(_ value: Any) -> String {
        let q = "\""

        switch value {
        case let value as String: return q + value + q
        default: return "(" + String(describing: type(of: value)) + ")"
        }
    }

    internal override func print(to p: PrettyPrinter) {
        if _children.isEmpty {
            p.write("<" + tagName)
            printAttributes(to: p)
            p.write(" />")
            return
        }

        p.write("<" + tagName)
        printAttributes(to: p)
        p.write(">")
        p.nest {
            for x in _children {
                x.print(to: p)
                p.writeNewline()
            }
        }
        p.write("</" + tagName + ">")
    }
}
