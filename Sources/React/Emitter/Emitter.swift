import SRTCore

package final class Emitter<Value> {
    final class Entry: IdentityHashable & Disposable {
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
        self.entries = []
    }

    private var entries: [Entry]

    func remove(entry: Entry) {
        entries.removeAll { $0 == entry }
    }

    public func on(handler: @escaping (Value) -> Void) -> any Disposable {
        let entry = Entry(
            emitter: self,
            handler: handler
        )
        entries.append(entry)
        return entry
    }

    public func emit(_ value: Value) {
        let entries = self.entries
        for entry in entries {
            entry.handler(value)
        }
    }
}

