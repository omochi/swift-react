import SRTCore

public protocol Component {
    func render() -> Node

    static func _extractGhost(_ input: GhostInput<Self>) -> Ghost
}

extension Component {
    public static func _extractGhost(_ input: GhostInput<Self>) -> Ghost {
        Ghost(
            component: input.component
        )
    }
}
