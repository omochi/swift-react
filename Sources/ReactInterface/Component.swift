import SRTCore

public protocol Component: Identifiable {
    associatedtype ID: Hashable = Empty

    func render() -> Node
}

extension Component {
    public var anyID: AnyHashable { id }
}

extension Component where ID == Empty {
    public var id: ID { Empty() }
}
