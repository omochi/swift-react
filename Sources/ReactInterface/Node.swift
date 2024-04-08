public typealias Node = (any Element)?

public typealias AnyNode = AnyElement?

extension Node {
    public func asAnyNode() -> AnyNode {
        self?.asAnyElement()
    }
}

extension [Node] {
    public func asAnyNodeArray() -> [AnyNode] {
        map { $0.asAnyNode() }
    }
}
