extension Fragment {
    public init(@ChildrenBuilder children: () -> [Node]) {
        let children = children()
        self.init(children: children)
    }
}
