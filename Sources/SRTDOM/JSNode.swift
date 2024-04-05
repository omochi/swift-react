import SRTCore
import JavaScriptKitShim

public struct JSNode: Equatable & Hashable & CustomStringConvertible & ConstructibleFromJSValue {
    public init(jsObject: JSObject) {
        self.jsObject = jsObject
    }

    public static func construct(from value: JSValue) -> Self? {
        value.object.map(Self.init(jsObject:))
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
        .construct(from: jsValue.childNodes)!
    }

    public var firstChild: JSNode? {
        JSNode?.construct(from: jsValue.firstChild)!
    }

    public var nextSibling: JSNode? {
        JSNode?.construct(from: jsValue.nextSibling)!
    }

    public var parentNode: JSNode? {
        JSNode?.construct(from: jsValue.parentNode)!
    }

    public func appendChild(_ node: JSNode) throws {
        _ = try jsValue.throws.appendChild(node.jsObject)
    }

    public func insertBefore(_ node: JSNode, _ ref: JSNode?) throws {
        _ = try jsValue.throws.insertBefore(node.jsObject, ref?.jsObject)
    }

    public func remove() throws {
        _ = try jsValue.throws.remove()
    }

    public func removeChild(_ node: JSNode) throws {
        _ = try jsValue.throws.removeChild(node.jsObject)
    }

    public var description: String {
        let p = PrettyPrinter()
        write(to: p)
        return p.output
    }

    package func index(of node: JSNode) -> Int? {
        childNodes.firstIndex { $0 == node }
    }

    package func insert(at location: JSNodeLocation) throws {
        try location.parent.insertBefore(self, location.next)
    }

    package func write(to p: PrettyPrinter) {
        do {
            // 😔
            if let x = asHTMLElement() {
                try x.write(to: p)
            } else if let x = asText() {
                x.write(to: p)
            } else {
                fatalError("JSNode.print is unimplemented")
            }
        } catch {
            p.write("(\(error))")
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


