import SRTCore
import SRTJavaScriptKitEx

public struct JSNodeList: ConvertibleToJSObject & ConstructibleFromJSValue {
    public init(jsObject: JSObject) {
        self.jsObject = jsObject
    }

    public static func construct(from value: JSValue) -> Self? {
        value.object.map(Self.init)
    }

    public var jsObject: JSObject

    public var length: Int {
        .unsafeConstruct(from: jsValue.length)
    }

    public func item(_ index: Int) throws -> JSNode? {
        try .mustConstruct(from: try jsValue.throws.item(index))
    }

    public subscript(index: Int) -> JSNode? {
        .unsafeConstruct(from: jsValue[index])
    }
}

extension JSNodeList: RandomAccessCollection {
    public typealias Element = JSNode?
    public typealias Index = Int

    public var startIndex: Int { 0 }
    public var endIndex: Int { length }
}
