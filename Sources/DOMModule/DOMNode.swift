import SRTCore

public class DOMNode: CustomStringConvertible {
    internal init() {
    }

    public var parent: DOMParentNode? { _parent }

    public func removeFromParent() {
        _parent?._removeChild(self)
    }

    internal weak var _parent: DOMParentNode?

    public var description: String {
        let p = PrettyPrinter()
        print(to: p)
        return p.output
    }

    internal func print(to p: PrettyPrinter) {
        fatalError()
    }

    public var location: DOMLocation? {
        guard let parent else { return nil }
        return DOMLocation(
            parent: parent,
            index: parent.index(of: self)!
        )
    }
}


