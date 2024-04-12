public protocol ContextValue: Hashable {
    static var defaultValue: Self { get }
}
