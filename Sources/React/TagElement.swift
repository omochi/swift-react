import Collections
import ReactInterface

public typealias TagAttributes = OrderedDictionary<String, String>

public struct TagElement: ReactElement {
    public init(
        tagName: String,
        attributes: TagAttributes = [:],
        children: [ReactNode] = []
    ) {
        self.tagName = tagName
        self.attributes = attributes
        self.children = children
    }

    public var tagName: String
    public var attributes: TagAttributes
    public var children: [ReactNode]

    public func render() -> ReactNode { self }
}
