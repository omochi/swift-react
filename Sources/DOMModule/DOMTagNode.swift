import SRTCore

public final class DOMTagNode: DOMParentNode {
    public init(
        tagName: String,
        strings: DOMStringAttributes = [:],
        eventHandlers: DOMEventHandlerAttributes = [:],
        children: [DOMNode] = []
    ) {
        self.tagName = tagName
        self.strings = strings
        self.eventHandlers = eventHandlers

        super.init()

        for x in children {
            appendChild(x)
        }
    }

    public var tagName: String
    public var strings: DOMStringAttributes
    public var eventHandlers: DOMEventHandlerAttributes

    private func printAttributes(to p: PrettyPrinter) {
        let q = "\""

        for k in strings.keys.sorted() {
            let v = strings[k]!
            p.write(space: " ", "\(k)=\(q)\(v)\(q)")
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
