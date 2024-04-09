public final class Function<R, each A>: Hashable {
    public init(
        _ body: @escaping (repeat each A) -> R
    ) {
        self.body = body
    }

    public var body: (repeat each A) -> R

    public func callAsFunction(_ args: repeat each A) -> R {
       body(repeat each args)
    }

    public static func ==(a: Function<R, repeat each A>, b: Function<R, repeat each A>) -> Bool {
        a === b
    }

    public func hash(into hasher: inout Hasher) {
        hasher.combine(ObjectIdentifier(self))
    }
}
