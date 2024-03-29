import SRTCore

struct AnyElementComponent: ReactComponent {
    public typealias ID = AnyHashable

    public var id: ID { anyID }

    public init(_ element: any ReactElement) {
        self.element = element
    }

    public var element: any ReactElement

    public func render() -> ReactNode {
        element
    }
}

extension ReactElement {
    public func asComponent() -> some ReactComponent {
        AnyElementComponent(self)
    }
}

struct IDComponent<IDType: Hashable>: ReactComponent {
    typealias ID = Tuple2<AnyHashable, IDType>

    var id: ID
    var element: any ReactComponent

    func render() -> ReactNode {
        element.render()
    }
}

extension ReactElement {
    public func id<ID: Hashable>(_ id: ID) -> some ReactComponent {
        return IDComponent<ID>(
            id: Tuple2(self.anyID, id),
            element: self.asComponent()
        )
    }
}
