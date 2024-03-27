import Collections
import ReactInterface

public typealias TagAttributes = OrderedDictionary<String, String>

public struct TagElement: ReactNode {
    public init(
        tagName: String,
        attributes: TagAttributes = [:],
        children: [any ReactNode] = []
    ) {
        self.tagName = tagName
        self.attributes = attributes
        self.children = children
    }

    public var tagName: String
    public var attributes: TagAttributes
    public var children: [any ReactNode]
}
