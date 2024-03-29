import SRTCore

struct IDComponent<IDType: Hashable>: Component {
    typealias ID = Tuple2<AnyHashable, IDType>

    var id: ID
    var component: any Component

    func render() -> Node {
        component.render()
    }
}

extension Component {
    public func id<ID: Hashable>(_ id: ID) -> some Component {
        return IDComponent<ID>(
            id: Tuple2(AnyHashable(self.id), id),
            component: self
        )
    }
}
