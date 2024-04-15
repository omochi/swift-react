public protocol ContextValue: Hashable {
    static var defaultValue: Self { get }
}

extension ContextValue {
    public static func undefinedDefault() -> Self {
        fatalError("default value is undefined")
    }
}
