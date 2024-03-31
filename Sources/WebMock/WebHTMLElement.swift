import SRTCore
import JavaScriptKitMock

public final class WebHTMLElement: WebNode {
    public init(
        _ tagName: String
    ) {
        self.tagName = tagName
    }

    public let tagName: String

    internal override func print(to p: PrettyPrinter) {
        if childNodes.isEmpty {
            p.write("<" + tagName)
//            printAttributes(to: p)
            p.write(" />")
            return
        }

        p.write("<" + tagName)
//        printAttributes(to: p)
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
        default: super._get_property(name)
        }
    }
}
