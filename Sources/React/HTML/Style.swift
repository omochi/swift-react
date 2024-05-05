public struct Style: Hashable & RawRepresentable & CustomStringConvertible {
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

    public func set(_ name: String, to value: String) -> Style {
        var copy = self
        copy[name] = value
        return copy
    }

    public mutating func merge(_ other: Style) {
        rawValue.merge(other.rawValue) { $1 }
    }

    public var description: String {
        let keys = self.keys.sorted()
        let lines: [String] = keys.map { (key) in
            let value = self[key]!
            return "\(key): \(value);"
        }
        return lines.joined(separator: "\n")
    }
}

extension Style: ExpressibleByDictionaryLiteral {
    public typealias Key = String
    public typealias Value = String

    public init(dictionaryLiteral: (Key, Value)...) {
        let value = Dictionary(uniqueKeysWithValues: dictionaryLiteral)
        self.init(value)
    }
}

extension Style: Sequence {
    public typealias Element = (key: Key, value: Value)

    public func makeIterator() -> some IteratorProtocol<Element> {
        rawValue.makeIterator()
    }
}

extension Style {
    public func display(_ x: String) -> Style {
        set("display", to: x)
    }

    public func flexDirection(_ x: String) -> Style {
        set("flex-direction", to: x)
    }

    public func alignItems(_ x: String) -> Style {
        set("align-items", to: x)
    }
    public func gap(_ x: String) -> Style {
        set("gap", to: x)
    }

    public func border(_ x: String) -> Style {
        set("border", to: x)
    }

    public func borderRadius(_ x: String) -> Style {
        set("border-radius", to: x)
    }

    public func padding(_ x: String) -> Style {
        set("padding", to: x)
    }
    public func margin(_ x: String) -> Style {
        set("margin", to: x)
    }
    public func width(_ x: String) -> Style {
        set("width", to: x)
    }

    public func height(_ x: String) -> Style {
        set("height", to: x)
    }

    public func flexWrap(_ x: String) -> Style {
        set("flex-wrap", to: x)
    }
    public func justifyContent(_ x: String) -> Style {
        set("justify-content", to: x)
    }
    public func fontSize(_ x: String) -> Style {
        set("font-size", to: x)
    }
    public func fontWeight(_ x: String) -> Style {
        set("font-weight", to: x)
    }
    public func fontFamily(_ x: String) -> Style {
        set("font-family", to: x)
    }
}
