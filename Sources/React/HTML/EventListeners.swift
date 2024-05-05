public struct EventListeners: Hashable & RawRepresentable {
    public typealias RawValue = [String: EventListener]

    public init(rawValue: [String: EventListener]) {
        self.rawValue = rawValue
    }

    public var rawValue: [String: EventListener]

    public init(_ value: [String: EventListener]) {
        self.rawValue = value
    }

    public subscript(name: String) -> EventListener? {
        get { rawValue[name] }
        set { rawValue[name] = newValue }
    }

    public var keys: some Collection<String> {
        rawValue.keys
    }

    public func set(_ name: String, to value: EventListener) -> EventListeners {
        var copy = self
        copy[name] = value
        return copy
    }

    public mutating func merge(_ other: EventListeners) {
        rawValue.merge(other.rawValue) { $1 }
    }
}

extension EventListeners: ExpressibleByDictionaryLiteral {
    public typealias Key = String
    public typealias Value = EventListener

    public init(dictionaryLiteral: (Key, Value)...) {
        let value = Dictionary(uniqueKeysWithValues: dictionaryLiteral)
        self.init(value)
    }
}

extension EventListeners: Sequence {
    public typealias Element = (key: Key, value: EventListener)

    public func makeIterator() -> some IteratorProtocol<Element> {
        rawValue.makeIterator()
    }
}

extension EventListeners {
    // @codegen(setters)
    public func abort(_ value: EventListener) -> EventListeners {
        set("abort", to: value)
    }

    public func afterprint(_ value: EventListener) -> EventListeners {
        set("afterprint", to: value)
    }

    public func auxclick(_ value: EventListener) -> EventListeners {
        set("auxclick", to: value)
    }

    public func beforematch(_ value: EventListener) -> EventListeners {
        set("beforematch", to: value)
    }

    public func beforeprint(_ value: EventListener) -> EventListeners {
        set("beforeprint", to: value)
    }

    public func beforetoggle(_ value: EventListener) -> EventListeners {
        set("beforetoggle", to: value)
    }

    public func beforeunload(_ value: EventListener) -> EventListeners {
        set("beforeunload", to: value)
    }

    public func blur(_ value: EventListener) -> EventListeners {
        set("blur", to: value)
    }

    public func cancel(_ value: EventListener) -> EventListeners {
        set("cancel", to: value)
    }

    public func canplay(_ value: EventListener) -> EventListeners {
        set("canplay", to: value)
    }

    public func canplaythrough(_ value: EventListener) -> EventListeners {
        set("canplaythrough", to: value)
    }

    public func change(_ value: EventListener) -> EventListeners {
        set("change", to: value)
    }

    public func click(_ value: EventListener) -> EventListeners {
        set("click", to: value)
    }

    public func close(_ value: EventListener) -> EventListeners {
        set("close", to: value)
    }

    public func contextlost(_ value: EventListener) -> EventListeners {
        set("contextlost", to: value)
    }

    public func contextmenu(_ value: EventListener) -> EventListeners {
        set("contextmenu", to: value)
    }

    public func contextrestored(_ value: EventListener) -> EventListeners {
        set("contextrestored", to: value)
    }

    public func copy(_ value: EventListener) -> EventListeners {
        set("copy", to: value)
    }

    public func cuechange(_ value: EventListener) -> EventListeners {
        set("cuechange", to: value)
    }

    public func cut(_ value: EventListener) -> EventListeners {
        set("cut", to: value)
    }

    public func dblclick(_ value: EventListener) -> EventListeners {
        set("dblclick", to: value)
    }

    public func drag(_ value: EventListener) -> EventListeners {
        set("drag", to: value)
    }

    public func dragend(_ value: EventListener) -> EventListeners {
        set("dragend", to: value)
    }

    public func dragenter(_ value: EventListener) -> EventListeners {
        set("dragenter", to: value)
    }

    public func dragleave(_ value: EventListener) -> EventListeners {
        set("dragleave", to: value)
    }

    public func dragover(_ value: EventListener) -> EventListeners {
        set("dragover", to: value)
    }

    public func dragstart(_ value: EventListener) -> EventListeners {
        set("dragstart", to: value)
    }

    public func drop(_ value: EventListener) -> EventListeners {
        set("drop", to: value)
    }

    public func durationchange(_ value: EventListener) -> EventListeners {
        set("durationchange", to: value)
    }

    public func emptied(_ value: EventListener) -> EventListeners {
        set("emptied", to: value)
    }

    public func ended(_ value: EventListener) -> EventListeners {
        set("ended", to: value)
    }

    public func error(_ value: EventListener) -> EventListeners {
        set("error", to: value)
    }

    public func focus(_ value: EventListener) -> EventListeners {
        set("focus", to: value)
    }

    public func formdata(_ value: EventListener) -> EventListeners {
        set("formdata", to: value)
    }

    public func hashchange(_ value: EventListener) -> EventListeners {
        set("hashchange", to: value)
    }

    public func input(_ value: EventListener) -> EventListeners {
        set("input", to: value)
    }

    public func invalid(_ value: EventListener) -> EventListeners {
        set("invalid", to: value)
    }

    public func keydown(_ value: EventListener) -> EventListeners {
        set("keydown", to: value)
    }

    public func keypress(_ value: EventListener) -> EventListeners {
        set("keypress", to: value)
    }

    public func keyup(_ value: EventListener) -> EventListeners {
        set("keyup", to: value)
    }

    public func languagechange(_ value: EventListener) -> EventListeners {
        set("languagechange", to: value)
    }

    public func load(_ value: EventListener) -> EventListeners {
        set("load", to: value)
    }

    public func loadeddata(_ value: EventListener) -> EventListeners {
        set("loadeddata", to: value)
    }

    public func loadedmetadata(_ value: EventListener) -> EventListeners {
        set("loadedmetadata", to: value)
    }

    public func loadstart(_ value: EventListener) -> EventListeners {
        set("loadstart", to: value)
    }

    public func message(_ value: EventListener) -> EventListeners {
        set("message", to: value)
    }

    public func messageerror(_ value: EventListener) -> EventListeners {
        set("messageerror", to: value)
    }

    public func mousedown(_ value: EventListener) -> EventListeners {
        set("mousedown", to: value)
    }

    public func mouseenter(_ value: EventListener) -> EventListeners {
        set("mouseenter", to: value)
    }

    public func mouseleave(_ value: EventListener) -> EventListeners {
        set("mouseleave", to: value)
    }

    public func mousemove(_ value: EventListener) -> EventListeners {
        set("mousemove", to: value)
    }

    public func mouseout(_ value: EventListener) -> EventListeners {
        set("mouseout", to: value)
    }

    public func mouseover(_ value: EventListener) -> EventListeners {
        set("mouseover", to: value)
    }

    public func mouseup(_ value: EventListener) -> EventListeners {
        set("mouseup", to: value)
    }

    public func offline(_ value: EventListener) -> EventListeners {
        set("offline", to: value)
    }

    public func online(_ value: EventListener) -> EventListeners {
        set("online", to: value)
    }

    public func pagehide(_ value: EventListener) -> EventListeners {
        set("pagehide", to: value)
    }

    public func pageshow(_ value: EventListener) -> EventListeners {
        set("pageshow", to: value)
    }

    public func paste(_ value: EventListener) -> EventListeners {
        set("paste", to: value)
    }

    public func pause(_ value: EventListener) -> EventListeners {
        set("pause", to: value)
    }

    public func play(_ value: EventListener) -> EventListeners {
        set("play", to: value)
    }

    public func playing(_ value: EventListener) -> EventListeners {
        set("playing", to: value)
    }

    public func popstate(_ value: EventListener) -> EventListeners {
        set("popstate", to: value)
    }

    public func progress(_ value: EventListener) -> EventListeners {
        set("progress", to: value)
    }

    public func ratechange(_ value: EventListener) -> EventListeners {
        set("ratechange", to: value)
    }

    public func rejectionhandled(_ value: EventListener) -> EventListeners {
        set("rejectionhandled", to: value)
    }

    public func reset(_ value: EventListener) -> EventListeners {
        set("reset", to: value)
    }

    public func resize(_ value: EventListener) -> EventListeners {
        set("resize", to: value)
    }

    public func scroll(_ value: EventListener) -> EventListeners {
        set("scroll", to: value)
    }

    public func scrollend(_ value: EventListener) -> EventListeners {
        set("scrollend", to: value)
    }

    public func securitypolicyviolation(_ value: EventListener) -> EventListeners {
        set("securitypolicyviolation", to: value)
    }

    public func seeked(_ value: EventListener) -> EventListeners {
        set("seeked", to: value)
    }

    public func seeking(_ value: EventListener) -> EventListeners {
        set("seeking", to: value)
    }

    public func select(_ value: EventListener) -> EventListeners {
        set("select", to: value)
    }

    public func slotchange(_ value: EventListener) -> EventListeners {
        set("slotchange", to: value)
    }

    public func stalled(_ value: EventListener) -> EventListeners {
        set("stalled", to: value)
    }

    public func storage(_ value: EventListener) -> EventListeners {
        set("storage", to: value)
    }

    public func submit(_ value: EventListener) -> EventListeners {
        set("submit", to: value)
    }

    public func suspend(_ value: EventListener) -> EventListeners {
        set("suspend", to: value)
    }

    public func timeupdate(_ value: EventListener) -> EventListeners {
        set("timeupdate", to: value)
    }

    public func toggle(_ value: EventListener) -> EventListeners {
        set("toggle", to: value)
    }

    public func unhandledrejection(_ value: EventListener) -> EventListeners {
        set("unhandledrejection", to: value)
    }

    public func unload(_ value: EventListener) -> EventListeners {
        set("unload", to: value)
    }

    public func volumechange(_ value: EventListener) -> EventListeners {
        set("volumechange", to: value)
    }

    public func waiting(_ value: EventListener) -> EventListeners {
        set("waiting", to: value)
    }

    public func wheel(_ value: EventListener) -> EventListeners {
        set("wheel", to: value)
    }
    // @end
}
