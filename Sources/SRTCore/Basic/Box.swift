public final class Box<Value> {
    public init(_ value: Value) {
        self.value = value
    }

    public convenience init() where Value: ExpressibleByNilLiteral {
        self.init(nil)
    }

    public var value: Value
}
