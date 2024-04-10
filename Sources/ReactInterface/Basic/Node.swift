import SRTCore

public typealias Node = (any Element)?

package enum Nodes {
    public static func normalize(node: Node) -> [any Component] {
        guard let node else { return [] }

        switch node {
        case let nodes as NodeCollection:
            return nodes.children.flatMap { (node) in
                normalize(node: node)
            }
        case let text as String:
            return [TextElement(text)]
        case let component as any Component:
            return [component]
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
