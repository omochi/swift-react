import SRTCore

public typealias Node = (any Element)?

public typealias NodeArray = Array<Node>

extension NodeArray: React.Element {}

package enum Nodes {
    public static func normalize(node: Node) -> [any Component] {
        guard let node else { return [] }

        switch node {
        case let component as any Component:
            return [component]
        case let array as NodeArray:
            return array.flatMap { (node) in
                normalize(node: node)
            }
        case let text as String:
            return [TextElement(text)]
        case let value as Int:
            return [TextElement(String(value))]
        case let value as Double:
            return [TextElement(String(value))]
        default:
            return []
        }
    }

    public static func normalize(nodes: [Node]) -> [any Component] {
        nodes.flatMap { (node) in
            normalize(node: node)
        }
    }
}
