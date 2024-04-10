public protocol IdentityHashable: Hashable & AnyObject {
}

extension IdentityHashable {
    public static func ==(a: Self, b: Self) -> Bool {
        a === b
    }

    public func hash(into hasher: inout Hasher) {
        hasher.combine(ObjectIdentifier(self))
    }
}
