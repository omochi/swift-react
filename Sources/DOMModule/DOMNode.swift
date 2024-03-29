import Collections
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

public class DOMParentNode: DOMNode {
    internal override init() {}

    public var children: [DOMNode] {
        get { _children }
        set {
            _children = newValue
            for x in _children {
                x._parent = self
            }
        }
    }

    internal var _children: [DOMNode] = []

    public func appendChild(_ child: DOMNode) {
        _children.append(child)
        child._parent = self
    }

    public func insertChild(_ child: DOMNode, at index: Int) {
        _children.insert(child, at: index)
        child._parent = self
    }

    internal func _removeChild(_ child: DOMNode) {
        _children.removeAll { $0 === child }
        child._parent = nil
    }
    
    public func index(of child: DOMNode) -> Int? {
        _children.firstIndex { $0 === child }
    }
}

public typealias DOMAttributes = OrderedDictionary<String, String>

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
                p.writeNewline()
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

public struct DOMLocation: Hashable {
    public init(
        parent: DOMParentNode,
        index: Int
    ) {
        self.parent = parent
        self.index = index
    }

    public var parent: DOMParentNode
    public var index: Int

    private var value: (ObjectIdentifier, Int) {
        (ObjectIdentifier(parent), index)
    }

    public static func ==(a: DOMLocation, b: DOMLocation) -> Bool {
        a.value == b.value
    }

    public func hash(into hasher: inout Hasher) {
        let value = self.value
        hasher.combine(value.0)
        hasher.combine(value.1)
    }
}
