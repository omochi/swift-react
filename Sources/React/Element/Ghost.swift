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
    
    var hooks: [any _AnyHookWrapper]
    var contextValue: (type: any ContextValue.Type, value: any ContextValue)?

    var states: [any _AnyStateHook] {
        hooks.compactMap { $0 as? any _AnyStateHook }
    }

    var contexts: [any _AnyContextHook] {
        hooks.compactMap { $0 as? any _AnyContextHook }
    }

    var effects: [any _AnyEffectHook] {
        hooks.compactMap { $0 as? any _AnyEffectHook }
    }
}
