@resultBuilder
public struct ChildrenBuilder {
    public static func buildPartialBlock(first: Node) -> [Node] {
        [first]
    }

    public static func buildPartialBlock<T: Element>(first: [T]) -> [Node] {
        first as NodeArray
    }

    public static func buildPartialBlock(accumulated: [Node], next: Node) -> [Node] {
        accumulated + [next]
    }

    public static func buildPartialBlock<T: Element>(accumulated: [Node], next: [T]) -> [Node] {
        accumulated + next as NodeArray
    }
}
