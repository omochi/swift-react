import SRTCore

public protocol Component: Element {
    var key: AnyHashable? { get }

    var deps: AnyHashable? { get }

    func render() -> Node

    static func _extractGhost(_ input: GhostInput<Self>) -> Ghost
}

extension Component {
    public var key: AnyHashable? { nil }

    public var deps: AnyHashable? { nil }

    package static func extractGhostDefault(_ input: GhostInput<Self>) -> Ghost {
        var hooks: [any _AnyHookWrapper] = []

        let mirror = Mirror(reflecting: input.component)
        for mc in mirror.children {
            switch mc.value {
            case let hook as any _AnyHookWrapper:
                hooks.append(hook)
            default: break
            }
        }

        return Ghost(
            component: input.component,
            hooks: hooks
        )
    }

    public static func _extractGhost(_ input: GhostInput<Self>) -> Ghost {
        extractGhostDefault(input)
    }
}
