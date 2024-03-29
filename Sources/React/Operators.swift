import SRTCore

struct IDComponent<C: Component, IDType: Hashable>: Component {
    typealias ID = Tuple2<C.ID, IDType>

    var id: ID
    var component: C

    func render() -> Node {
        component.render()
    }
}

extension Component {
    public func id<ID: Hashable>(_ id: ID) -> some Component {
        return IDComponent<Self, ID>(
            id: Tuple2(self.id, id),
            component: self
        )
    }
}
