import Collections
import SRTCore

public class DOMNode: CustomStringConvertible {
    internal init() {
    }

    public var parent: DOMNode? { _parent }

    public func removeFromParent() {
        (_parent as? DOMTagNode)?._removeChild(self)
    }

    internal weak var _parent: DOMNode?

    public var description: String {
        let p = PrettyPrinter()
        print(to: p)
        return p.output
    }

    internal func print(to p: PrettyPrinter) {
        fatalError()
    }
}

public typealias DOMAttributes = OrderedDictionary<String, String>

public final class DOMTagNode: DOMNode {
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

    public var children: [DOMNode] {
        get { _children }
        set {
            _children = newValue
            for x in _children {
                x._parent = self
            }
        }
    }

    private var _children: [DOMNode] = []

    public func appendChild(_ child: DOMNode) {
        _children.append(child)
        child._parent = self
    }

    internal func _removeChild(_ child: DOMNode) {
        _children.removeAll { $0 === child }
        child._parent = nil
    }

    private func printAttributes(to p: PrettyPrinter) {
        let q = "\""

        for (k, v) in attributes {
            p.write(space: " ", "\(k)=\(q + v + q)")
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
            }
        }
        p.write("</" + tagName + ">")
    }
}

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
