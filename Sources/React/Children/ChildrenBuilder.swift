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

    public static func buildIf(_ content: Node?) -> [Node] {
        switch content {
        case .some(let content): [content]
        case .none: []
        }
    }

    public static func buildIf<T: Element>(_ content: [T]?) -> [Node] {
        switch content {
        case .some(let content): content as NodeArray
        case .none: []
        }
    }

    public static func buildEither(first component: Node) -> [Node] {
        [component]
    }

    public static func buildEither<T: Element>(first component: [T]) -> [Node] {
        component as NodeArray
    }

    public static func buildEither(second component: Node) -> [Node] {
        [component]
    }

    public static func buildEither<T: Element>(second component: [T]) -> [Node] {
        component as NodeArray
    }
}
