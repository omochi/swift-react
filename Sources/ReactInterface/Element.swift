public protocol Element: Equatable {
    func asAnyElement() -> AnyElement
}

extension Element {
    public func asAnyElement() -> AnyElement {
        AnyElement(self)
    }
}

public struct AnyElement: Element {
    public init(_ value: any Element) {
        self.value = value
    }

    public var value: any Element

    public static func ==(a: AnyElement, b: AnyElement) -> Bool {
        func body<A: Element, B: Element>(_ a: A, _ b: B) -> Bool {
            guard A.self == B.self else { return false }
            return a == (b as! A)
        }
        return body(a, b)
    }

    public func asAnyElement() -> AnyElement { self }
}
