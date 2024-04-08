import SRTCore

public protocol Component: Equatable & Element {
    var key: AnyHashable? { get }

    func render() -> Node

    static func _extractGhost(_ input: GhostInput<Self>) -> Ghost
}

extension Component {
    public var key: AnyHashable? { nil }

    public static func _extractGhost(_ input: GhostInput<Self>) -> Ghost {
        Ghost(
            component: input.component
        )
    }
}
