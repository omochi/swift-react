@dynamicMemberLookup
public enum JSValue: Equatable & ConvertibleToJSValue & ConstructibleFromJSValue {
    case boolean(Bool)
    case string(JSString)
    case number(Double)
    case object(JSObject)
    case null
    case undefined
    case function(JSFunction)

    public var boolean: Bool? {
        switch self {
        case let .boolean(x): return x
        default: return nil
        }
    }
    
    public var jsString: JSString? {
        switch self {
        case let .string(x): return x
        default: return nil
        }
    }

    public var string: String? {
        jsString.map(String.init)
    }

    public var number: Double? {
        switch self {
        case let .number(x): return x
        default: return nil
        }
    }

    public var object: JSObject? {
        switch self {
        case let .object(x): return x
        default: return nil
        }
    }

    public var function: JSFunction? {
        switch self {
        case let .function(x): return x
        default: return nil
        }
    }

    public var isNull: Bool {
        return self == .null
    }

    public var isUndefined: Bool {
        return self == .undefined
    }

    public var jsValue: JSValue { self }

    public static func construct(from value: JSValue) -> JSValue? {
        value
    }
}


extension JSValue {
    @_disfavoredOverload
    public subscript(dynamicMember name: String) -> ((any ConvertibleToJSValue...) -> JSValue) {
        object![dynamicMember: name]!
    }

    public subscript(dynamicMember name: String) -> JSValue {
        get { self.object![name] }
        set { self.object![name] = newValue }
    }

    public subscript(_ index: Int) -> JSValue {
        get { object![index] }
        set { object![index] = newValue }
    }
}
