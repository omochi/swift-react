import SRTCore

public protocol ReactNode: Identifiable {
    associatedtype ID: Hashable = Empty

    func render() -> (any ReactNode)?
}

extension ReactNode where ID == Empty {
    public var id: ID { Empty() }
}

public protocol ReactComponent: ReactNode {
    func render() -> (any ReactNode)?
}

struct IDComponent<T: ReactNode, IDType: Hashable>: ReactComponent {
    typealias ID = Tuple2<T.ID, IDType>

    var id: ID
    var component: T

    func render() -> (any ReactNode)? {
        component.render()
    }
}

extension ReactNode {
    public func id<ID: Hashable>(_ id: ID) -> some ReactComponent {
        return IDComponent<Self, ID>(
            id: Tuple2(self.id, id),
            component: self
        )
    }
}
