public struct Attributes: Hashable & RawRepresentable {
    public typealias RawValue = [String: String]

    public init(rawValue: [String: String]) {
        self.rawValue = rawValue
    }

    public var rawValue: [String: String]

    public init(_ value: [String: String]) {
        self.rawValue = value
    }

    public subscript(name: String) -> String? {
        get { rawValue[name] }
        set { rawValue[name] = newValue }
    }

    public var keys: some Collection<String> {
        rawValue.keys
    }

    public func updated(_ name: String, to value: String) -> Attributes {
        var copy = self
        copy[name] = value
        return copy
    }

    public mutating func merge(_ other: Attributes) {
        rawValue.merge(other.rawValue) { $1 }
    }
}

extension Attributes: ExpressibleByDictionaryLiteral {
    public typealias Key = String
    public typealias Value = String

    public init(dictionaryLiteral: (Key, Value)...) {
        let value = Dictionary(uniqueKeysWithValues: dictionaryLiteral)
        self.init(value)
    }
}

extension Attributes: Sequence {
    public typealias Element = (key: Key, value: Value)

    public func makeIterator() -> some IteratorProtocol<Element> {
        rawValue.makeIterator()
    }
}

extension Attributes {
    public func `class`(_ x: String) -> Attributes {
        updated("class", to: x)
    }

    public func style(_ x: String) -> Attributes {
        updated("style", to: x)
    }

    public func href(_ x: String) -> Attributes {
        updated("href", to: x)
    }

    public func rows(_ x: String) -> Attributes {
        updated("rows", to: x)
    }

    public func placeholder(_ x: String) -> Attributes {
        updated("placeholder", to: x)
    }
}
