import SRTDOM

package final class Instance {
    final class ListenerBridge {
        init() {}

        var js: JSEventListener?
        var swift: EventListener?
    }

    init() {
        
    }

    weak var owner: VNode?
    var hooks: [AnyObject] = []
    public var dom: JSNode?
    var attributes: Attributes = Attributes()
    var listeners: [String: ListenerBridge] = [:]
    var contextValueHolder: ContextValueHolder?
    var isDirty: Bool = false

    var contextHooks: [any _AnyContextHookObject] {
        hooks.compactMap { $0 as? any _AnyContextHookObject }
    }

    var stateHooks: [any _AnyStateHookObject] {
        hooks.compactMap { $0 as? any _AnyStateHookObject }
    }

    var effectHooks: [Effect.Object] {
        hooks.compactMap { $0 as? Effect.Object }
    }

    func renderDOMAttributes(
        attributes newAttributes: Attributes?
    ) throws {
        let newAttributes = newAttributes ?? Attributes()

        let dom = try (self.dom?.asHTMLElement()).unwrap("dom.asHTMLElement")
        let oldAttributes = self.attributes

        for name in self.attributes.keys {
            if newAttributes[name] == nil {
                try dom.removeAttribute(name)
            }
        }

        for (name, newValue) in newAttributes {
            if newValue != oldAttributes[name] {
                try dom.setAttribute(name, newValue)
            }
        }

        self.attributes = newAttributes
    }

    func renderDOMListeners(
        listeners newListeners: EventListeners?
    ) throws {
        let newListeners = newListeners ?? EventListeners()

        let dom = try (self.dom?.asHTMLElement()).unwrap("dom.asHTMLElement")

        for (type, bridge) in Array(self.listeners) {
            if bridge.swift != newListeners[type] {
                if let js = bridge.js {
                    try dom.removeEventListener(type, js)
                }
                self.listeners[type] = nil
            }
        }

        for (type, newListener) in newListeners {
            if let bridge = self.listeners[type] {
                if newListener == bridge.swift {
                    continue
                }

                bridge.swift = newListener
            } else {
                let bridge = ListenerBridge()
                self.listeners[type] = bridge

                let js = JSEventListener { [weak bridge] (event) in
                    guard let bridge, let swift = bridge.swift else { return }
                    swift(event)
                }

                bridge.js = js
                bridge.swift = newListener

                try dom.addEventListener(type, js)
            }
        }
    }

    func markDirty() {
        isDirty = true
    }

    func consumeDirty() -> Bool {
        defer { isDirty = false }
        return isDirty
    }

}
