public struct Tuple2<T0, T1> {
    public init(
        _ t0: T0,
        _ t1: T1
    ) {
        self.t0 = t0
        self.t1 = t1
    }

    public var t0: T0
    public var t1: T1
}

extension Tuple2: Equatable where T0: Equatable, T1: Equatable {
}

extension Tuple2: Hashable where T0: Hashable, T1: Hashable {
}
