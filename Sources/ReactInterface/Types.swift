import SRTCore

public typealias ReactNode = (any ReactElement)?

public protocol ReactElement {
    var anyID: AnyHashable { get }
}

extension ReactElement {
    public var anyID: AnyHashable { Empty() }
}

public protocol ReactComponent: ReactElement & Identifiable {
    associatedtype ID: Hashable = Empty

    func render() -> ReactNode
}

extension ReactComponent {
    public var anyID: AnyHashable { AnyHashable(id) }
}

extension ReactComponent where ID == Empty {
    public var id: ID { Empty() }
}

public struct ReactFragment: ReactElement {
    public init(_ children: [ReactNode] = []) {
        self.children = children
    }

    public var children: [ReactNode]

    public func render() -> ReactNode { self }
}
