import SRTCore

public final class Function<R, each A>: IdentityHashable {
    public init(
        _ body: @escaping (repeat each A) -> R
    ) {
        self.body = body
    }

    public var body: (repeat each A) -> R

    public func callAsFunction(_ args: repeat each A) -> R {
       body(repeat each args)
    }
}
