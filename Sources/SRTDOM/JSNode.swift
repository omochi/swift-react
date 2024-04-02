import SRTCore
import JavaScriptKitShim

public struct JSNode: Equatable & Hashable & CustomStringConvertible {
    public init(jsObject: JSObject) {
        self.jsObject = jsObject
    }

    public let jsObject: JSObject
    public var jsValue: JSValue { .object(jsObject) }

    public func asHTMLElement() -> JSHTMLElement? {
        if jsObject.isInstanceOf(JSWindow.global.HTMLElement) {
           return JSHTMLElement(jsObject: jsObject)
        } else {
           return nil
        }
    }

    public func asText() -> JSText? {
        if jsObject.isInstanceOf(JSWindow.global.Text) {
           return JSText(jsObject: jsObject)
        } else {
           return nil
        }
    }

    public var childNodes: JSNodeList {
        JSNodeList(jsObject: jsValue.childNodes.object!)
    }

    public var firstChild: JSNode? {
        jsValue.firstChild.object.map(JSNode.init)
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
        write(to: p)
        return p.output
    }

    package func index(of node: JSNode) -> Int? {
        childNodes.firstIndex { $0 == node }
    }

    package func insert(at location: JSNodeLocation) {
        location.parent.insertBefore(self, location.next)
    }

    package func write(to p: PrettyPrinter) {
        // 😔
        if let x = asHTMLElement() {
            x.write(to: p)
        } else if let x = asText() {
            x.write(to: p)
        } else {
            fatalError("JSNode.print is unimplemented")
        }
    }

    public var location: JSNodeLocation? {
        guard let parent = parentNode else { return nil }
        return JSNodeLocation(
            parent: parent,
            next: nextSibling
        )
    }
}


