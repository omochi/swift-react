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
        var hooks: [String: any _AnyHookObject] = [:]

        let mirror = Mirror(reflecting: input.component)
        for mc in mirror.children {
            guard let label = mc.label else { continue }

            switch mc.value {
            case let hook as any _AnyHookWrapper:
                hooks[label] = hook._anyHookObject
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
