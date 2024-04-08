public struct GhostInput<C: Component> {
    package init(
        component: C
    ) {
        self.component = component
    }
    
    package var component: C
}

public struct Ghost {
    package var component: any Component
}
