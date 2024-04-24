import SRTCore

public protocol Component: Element {
    var key: AnyHashable? { get }

    var deps: Deps? { get }

    func render() -> Node
}

extension Component {
    public var key: AnyHashable? { nil }

    public var deps: Deps? { nil }
}

enum Components {
    static func extractHooks(_ value: Any) -> [any _AnyHookWrapper] {
        var hooks: [any _AnyHookWrapper] = []

        let mirror = Mirror(reflecting: value)
        for mc in mirror.children {
            switch mc.value {
            case let hook as any _AnyHookWrapper:
                hooks.append(hook)
            case let hook as any Hook:
                hooks += extractHooks(hook)
            default: break
            }
        }

        return hooks
    }
}
