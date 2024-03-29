import SRTCore

public final class DOMTextNode: DOMNode {
    public init(
        text: String
    ) {
        self.text = text
        super.init()
    }

    public var text: String

    internal override func print(to p: PrettyPrinter) {
        p.write(text)
    }
}
