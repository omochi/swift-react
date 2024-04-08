public protocol BypassedEquatable: Equatable {
}

extension BypassedEquatable {
    public static func ==(a: Self, b: Self) -> Bool { true }
}
