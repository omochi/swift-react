@propertyWrapper
public final class Effect: _AnyHookWrapper {
    public typealias Setup = () -> Cleanup?
    public typealias Cleanup = () -> Void

    public init() {
    }

    public var wrappedValue: Never {
        fatalError("Effect has no value")
    }

    public var projectedValue: Projection {
        Projection(object: object!)
    }

    public struct Projection {
        public func callAsFunction(
            deps: AnyHashable? = nil,
            setup: @escaping Setup
        ) {
            object.deps = deps
            object.setup = setup
        }

        var object: Object
    }

    func prepare(object: Object?) {
        self.object = object ?? Object()
    }

    var object: Object?

    final class Object {
        init() {}

        var deps: AnyHashable?
        var setup: Setup?
        var cleanup: Cleanup?
    }
}
