@propertyWrapper
public final class Callback<R, each A>: _AnyHookWrapper {
    public init() {
    }

    public var wrappedValue: Function<R, repeat each A> {
        guard let function = object!.function else {
            preconditionFailure("uninitialized")
        }
        return function
    }

    public var projectedValue: Projection {
        Projection(object: object!)
    }

    func prepare(object: Object?) {
        self.object = object ?? Object()
    }

    var object: Object?

    public struct Projection {
        public func callAsFunction(
            deps: AnyHashable,
            impl: @escaping (repeat each A) -> R
        ) {
            if object.function == nil ||
                object.deps != deps
            {
                object.function = Function(impl)
            }

            object.deps = deps
        }

        var object: Object
    }

    final class Object {
        var deps: AnyHashable?
        var function: Function<R, repeat each A>?
    }
}
