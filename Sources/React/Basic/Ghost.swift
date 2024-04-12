public struct GhostInput<C: Component> {
    public init(
        component: C
    ) {
        self.component = component
    }
    
    public var component: C
}

public struct Ghost {
    public var component: any Component
    package var hooks: [String: any _AnyHookObject]

    package var states: [String: any _AnyStateStorage] {
        hooks.compactMapValues { $0 as? any _AnyStateStorage }
    }
}
