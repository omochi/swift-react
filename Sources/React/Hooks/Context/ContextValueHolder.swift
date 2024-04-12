package final class ContextValueHolder {
    public init(type: any ContextValue.Type) {
        self.emitter = Emitter()
        self.type = type
    }

    public let type: any ContextValue.Type
    private var _value: (any ContextValue)?
    public var emitter: Emitter<Void>

    public var value: any ContextValue {
        get { _value! }
        set {
            setValue(newValue)
        }
    }

    private func setValue<T: ContextValue>(_ value: T) {
        guard value != (_value as? T) else { return }
        _value = value
        emitter.emit(())
    }
}
