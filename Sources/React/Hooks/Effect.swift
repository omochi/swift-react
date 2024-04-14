@propertyWrapper
public struct Effect: _AnyHookWrapper {
    public typealias Setup = () -> Cleanup?
    public typealias Cleanup = () -> Void

    public init() {
        self.storage = Storage()
    }

    public var wrappedValue: Never {
        fatalError("Effect has no value")
    }

    public var projectedValue: Projection {
        Projection(storage: storage)
    }

    public struct Projection {
        public func callAsFunction(
            deps: AnyHashable? = nil,
            setup: @escaping Setup
        ) {
            storage.deps = deps
            storage.setup = setup
        }

        var storage: Storage
    }

    private var storage: Storage

    package var _anyHookObject: any _AnyHookObject { storage }

    package final class Storage: _AnyHookObject {
        var deps: AnyHashable?
        var setup: Setup?
        var cleanup: Cleanup?

        init() {}

        public func _take(fromAnyHookObject object: any _AnyHookObject) {
            guard let o = object as? Storage else { return }

            // ?
        }
    }
}
