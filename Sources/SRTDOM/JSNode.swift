import SRTCore
import JavaScriptKitShim

public class JSNode: Equatable & Hashable & CustomStringConvertible {
    public init(jsObject: JSObject) {
        self.jsObject = jsObject
    }

    public let jsObject: JSObject
    public var jsValue: JSValue { .object(jsObject) }

    public static func ==(a: JSNode, b: JSNode) -> Bool { a.jsObject == b.jsObject }

    public func hash(into hasher: inout Hasher) {
        hasher.combine(jsObject)
    }

    public var childNodes: JSNodeList {
        JSNodeList(jsObject: jsValue.childNodes.object!)
    }

    public var nextSibling: JSNode? {
        jsValue.nextSibling.object.map(JSNode.init)
    }

    public var parentNode: JSNode? {
        jsValue.parentNode.object.map(JSNode.init)
    }

    public func appendChild(_ node: JSNode) {
        jsValue.appendChild(node.jsObject)
    }

    public func insertBefore(_ node: JSNode, _ ref: JSNode?) {
        jsValue.insertBefore(node.jsObject, ref?.jsObject)
    }

    public func remove() {
        jsValue.remove()
    }

    public func removeChild(_ node: JSNode) {
        jsValue.removeChild(node.jsObject)
    }

    public var description: String {
        let p = PrettyPrinter()
        print(to: p)
        return p.output
    }

    package func index(of node: JSNode) -> Int? {
        childNodes.firstIndex { $0 == node }
    }

    package func insert(at location: JSNodeLocation) {
        location.parent.insertBefore(self, location.next)
    }

    package func print(to p: PrettyPrinter) {
        fatalError()
    }

    public var location: JSNodeLocation? {
        guard let parent = parentNode else { return nil }
        return JSNodeLocation(
            parent: parent,
            next: nextSibling
        )
    }
}


