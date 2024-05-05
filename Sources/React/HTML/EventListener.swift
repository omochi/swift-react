import SRTDOM

public typealias EventListener = Function<Void, JSEvent>

public struct EventListeners: Hashable & RawRepresentable {
    public typealias RawValue = [String: EventListener]

    public init(rawValue: [String: EventListener]) {
        self.rawValue = rawValue
    }

    public var rawValue: [String: EventListener]

    public init(_ value: [String: EventListener]) {
        self.rawValue = value
    }

    public subscript(name: String) -> EventListener? {
        get { rawValue[name] }
        set { rawValue[name] = newValue }
    }

    public var keys: some Collection<String> {
        rawValue.keys
    }

    public func set(_ name: String, to value: EventListener) -> EventListeners {
        var copy = self
        copy[name] = value
        return copy
    }

    public mutating func merge(_ other: EventListeners) {
        rawValue.merge(other.rawValue) { $1 }
    }
}

extension EventListeners: ExpressibleByDictionaryLiteral {
    public typealias Key = String
    public typealias Value = EventListener

    public init(dictionaryLiteral: (Key, Value)...) {
        let value = Dictionary(uniqueKeysWithValues: dictionaryLiteral)
        self.init(value)
    }
}

extension EventListeners: Sequence {
    public typealias Element = (key: Key, value: EventListener)

    public func makeIterator() -> some IteratorProtocol<Element> {
        rawValue.makeIterator()
    }
}

extension EventListeners {
    public func click(_ x: EventListener) -> EventListeners {
        set("click", to: x)
    }

    public func change(_ x: EventListener) -> EventListeners {
        set("change", to: x)
    }

    public func input(_ x: EventListener) -> EventListeners {
        set("input", to: x)
    }
}



