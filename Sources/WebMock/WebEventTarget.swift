import JavaScriptKitMock

public class WebEventTarget: JSNativeObject {
    public init() {
    }

    private var listeners: [String: [JSFunction]] = [:]

    public func addEventListener(_ type: String, _ listener: JSFunction) {
        var lns = self.listeners[type] ?? []
        if lns.contains(listener) { return }
        lns.append(listener)
        self.listeners[type] = lns
    }

    public func removeEventListener(_ type: String, _ listener: JSFunction) {
        guard var lns = self.listeners[type] else { return }
        lns.removeAll { $0 == listener }
        self.listeners[type] = lns
    }

    public func dispatchEvent(_ event: WebEvent) -> Bool {
        guard let lns = self.listeners[event.type] else { return true }
        for ln in lns {
            ln(event)
        }
        return true
    }

    public func _get_property(_ name: String) -> JSValue {
        switch name {
        case "addEventListener": JSFunction(Self.addEventListener).jsValue
        case "removeEventListener": JSFunction(Self.removeEventListener).jsValue
        case "dispatchEvent": JSFunction(Self.dispatchEvent).jsValue
        default: .undefined
        }
    }

    public func _set_property(_ name: String, _ value: JSValue) {
    }

    public func _isInstanceOf(_ constructor: JSFunction) -> Bool {
        return false
    }
}
