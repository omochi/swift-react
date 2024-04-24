import SRTCore

@propertyWrapper
public struct Effect: _AnyEffectHook {
    public typealias Setup = () -> Cleanup?
    public typealias Cleanup = () -> Void

    public init() {
    }

    public var wrappedValue: Empty { Empty() }

    public var projectedValue: Projection {
        Projection(object: object)
    }

    public struct Projection {
        public func callAsFunction(
            deps: Deps? = nil,
            setup: @escaping Setup
        ) {
            let shouldExecute: Bool = {
                guard let deps else { return true }

                return deps != object.deps
            }()

            object.shouldExecute = shouldExecute
            object.deps = deps
            object.setup = setup
        }

        var object: Object
    }

    func prepare(object: Object?) {
        _object.value = object ?? Object()
    }

    private let _object: Box<Object?> = Box()

    var object: Object { _object.value! }

    var effectObject: Effect.Object { object }

    final class Object {
        init() {}

        var shouldExecute: Bool = false
        var deps: Deps?
        var setup: Setup?
        var cleanup: Cleanup?

        func taskIfShouldExecute() -> Task? {
            guard shouldExecute else { return nil }
            shouldExecute = false
            return Task(object: self, setup: setup)
        }

        func cleanupTask() -> Task? {
            if cleanup == nil { return nil }
            return Task(object: self, setup: nil)
        }
    }

    final class Task {
        init(
            object: Object,
            setup: Setup?
        ) {
            self.object = object
            self.setup = setup
        }

        let object: Object
        var setup: Setup?

        func run() {
            if let oldCleanup = object.cleanup {
                object.cleanup = nil

                oldCleanup()
            }

            if let setup {
                let newCleanup = setup()
                object.cleanup = newCleanup
            }
        }
    }
}

protocol _AnyEffectHook: _AnyHookWrapper {
    var effectObject: Effect.Object { get }
}
