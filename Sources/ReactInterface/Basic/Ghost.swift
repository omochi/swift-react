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
    package var refs: [String: any _AnyRefObject]
    package var states: [String: any _AnyStateStorage]
}
