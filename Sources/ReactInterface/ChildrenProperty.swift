@propertyWrapper
public struct ChildrenProperty: Equatable {
    public init(wrappedValue: [Node]) {
        self.wrappedValue = wrappedValue
    }

    public var wrappedValue: [Node]

    public static func ==(a: Self, b: Self) -> Bool {
        let a = a.wrappedValue.asAnyNodeArray()
        let b = b.wrappedValue.asAnyNodeArray()
        return a == b
    }
}
