import SRTCore

package final class Emitter<Value> {
    final class EmitterEntry: IdentityHashable & Disposable {
        init(
            emitter: Emitter<Value>,
            handler: @escaping (Value) -> Void
        ) {
            self.emitter = emitter
            self.handler = handler
        }
        
        weak var emitter: Emitter<Value>?
        let handler: (Value) -> Void

        func dispose() {
            emitter?.remove(entry: self)
        }
    }

    public init() {
        self.handlers = []
    }

    private var handlers: [EmitterEntry]

    func remove(entry: EmitterEntry) {
        handlers.removeAll { $0 == entry }
    }

    public func on(handler: @escaping (Value) -> Void) -> any Disposable {
        let entry = EmitterEntry(
            emitter: self,
            handler: handler
        )
        handlers.append(entry)
        return entry
    }

    public func emit(_ value: Value) {
        let handlers = self.handlers
        for handler in handlers {
            handler.handler(value)
        }
    }
}

