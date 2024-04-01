import SRTCore
import JavaScriptKitShim

public class JSNodeList {
    public init(jsObject: JSObject) {
        self.jsObject = jsObject
    }

    public let jsObject: JSObject
    public var jsValue: JSValue { .object(jsObject) }

    public var length: Int {
        .construct(from: jsValue.length)!
    }

    public func item(_ index: Int) -> JSNode? {
        jsValue.item(index).object.map(JSNode.init)
    }

    public subscript(index: Int) -> JSNode? {
        jsValue[index].object.map(JSNode.init)
    }
}

extension JSNodeList: RandomAccessCollection {
    public typealias Element = JSNode?
    public typealias Index = Int

    public var startIndex: Int { 0 }
    public var endIndex: Int { length }
}
