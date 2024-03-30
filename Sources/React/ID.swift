import SRTCore

struct IDComponent<C: Component, ID: Hashable>: Component {
    var component: C
    var id: ID

    func render() -> Node {
        component.render()
    }

    static func _extractGhost(_ input: GhostInput<IDComponent<C, ID>>) -> Ghost {
        let wrapper = input.component
        var ghost = C._extractGhost(GhostInput<C>(component: wrapper.component))
        ghost.id = wrapper.id
        return ghost
    }
}

extension Component {
    public func id<ID: Hashable>(_ id: ID) -> some Component {
        return IDComponent<Self, ID>(component: self, id: id)
    }
}
