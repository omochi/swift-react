import SRTCore

public protocol Component: Equatable & Element {
    var key: AnyHashable? { get }

    func render() -> Node

    static func _extractGhost(_ input: GhostInput<Self>) -> Ghost
}

extension Component {
    public var key: AnyHashable? { nil }

    public static func _extractGhost(_ input: GhostInput<Self>) -> Ghost {
        var refs: [String: any _AnyRefObject] = [:]

        let mirror = Mirror(reflecting: input.component)
        for mc in mirror.children {
            guard let label = mc.label else { continue }

            switch mc.value {
            case let ref as any _AnyRef:
                let obj = ref._anyRefObject
                refs[label] = obj
            default: break
            }
        }

        return Ghost(
            component: input.component,
            refs: refs
        )
    }
}
