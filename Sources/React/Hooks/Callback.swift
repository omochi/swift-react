@propertyWrapper
public struct Callback<R, each A>: _AnyCallback {
    public init() {
        self.storage = Storage()
    }

    public var wrappedValue: Function<R, repeat each A> {
        guard let function = storage.function else {
            preconditionFailure("uninitialized")
        }
        return function
    }

    public var projectedValue: Projection {
        Projection(storage: storage)
    }

    public struct Projection {
        public func callAsFunction(
            deps: AnyHashable,
            impl: @escaping (repeat each A) -> R
        ) {
            if storage.function == nil ||
                storage.deps != deps
            {
                storage.function = Function(impl)
            }

            storage.deps = deps
        }

        var storage: Storage
    }

    package final class Storage: _AnyCallbackStorage {
        var deps: AnyHashable?
        var function: Function<R, repeat each A>?

        package func _take(fromAnyHookObject object: any _AnyHookObject) {
            guard let o = object as? Storage else { return }

            deps = o.deps
            function = o.function
        }
    }

    var storage: Storage
    package var _anyCallbackStorage: any _AnyCallbackStorage { storage }
    package var _anyHookObject: any _AnyHookObject { _anyCallbackStorage }
}

package protocol _AnyCallback: _AnyHookWrapper {
    var _anyCallbackStorage: any _AnyCallbackStorage { get }
}

package protocol _AnyCallbackStorage: _AnyHookObject {
}
