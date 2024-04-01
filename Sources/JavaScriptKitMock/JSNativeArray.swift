public final class JSNativeArray: JSNativeObject {
    public init() {
        self._elements = []
    }

    private var _elements: [JSValue]

    public var length: Int { _elements.count }

    public subscript(index: Int) -> JSValue {
        get {
            guard 0..<_elements.count ~= index else {
                return .undefined
            }
            return _elements[index]
        }
        set {
            _elements[index] = newValue
        }
    }

    public func push(_ element: JSValue) {
        _elements.append(element)
    }

    public func _get_index(_ index: Int) -> JSValue {
        self[index]
    }

    public func _set_index(_ index: Int, _ value: JSValue) {
        self[index] = value
    }

    public func _get_property(_ name: String) -> JSValue {
        switch name {
        case "length": length.jsValue
        case "push": JSFunction(Self.push).jsValue
        default: .undefined
        }
    }
}
