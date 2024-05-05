public struct Attributes: Hashable & RawRepresentable {
    public typealias RawValue = [String: String]

    public init(rawValue: [String: String]) {
        self.rawValue = rawValue
    }

    public var rawValue: [String: String]

    public init(_ value: [String: String]) {
        self.rawValue = value
    }

    public subscript(name: String) -> String? {
        get { rawValue[name] }
        set { rawValue[name] = newValue }
    }

    public var keys: some Collection<String> {
        rawValue.keys
    }

    public func set(_ name: String, to value: String) -> Attributes {
        var copy = self
        copy[name] = value
        return copy
    }

    public mutating func merge(_ other: Attributes) {
        rawValue.merge(other.rawValue) { $1 }
    }
}

extension Attributes: ExpressibleByDictionaryLiteral {
    public typealias Key = String
    public typealias Value = String

    public init(dictionaryLiteral: (Key, Value)...) {
        let value = Dictionary(uniqueKeysWithValues: dictionaryLiteral)
        self.init(value)
    }
}

extension Attributes: Sequence {
    public typealias Element = (key: Key, value: Value)

    public func makeIterator() -> some IteratorProtocol<Element> {
        rawValue.makeIterator()
    }
}

extension Attributes {
    // @codegen(setters)
    public func accesskey(_ value: String) -> Attributes {
        set("accesskey", to: value)
    }

    public func autocapitalize(_ value: String) -> Attributes {
        set("autocapitalize", to: value)
    }

    public func autofocus(_ value: String) -> Attributes {
        set("autofocus", to: value)
    }

    public func `class`(_ value: String) -> Attributes {
        set("class", to: value)
    }

    public func contenteditable(_ value: String) -> Attributes {
        set("contenteditable", to: value)
    }

    public func dir(_ value: String) -> Attributes {
        set("dir", to: value)
    }

    public func draggable(_ value: String) -> Attributes {
        set("draggable", to: value)
    }

    public func enterkeyhint(_ value: String) -> Attributes {
        set("enterkeyhint", to: value)
    }

    public func hidden(_ value: String) -> Attributes {
        set("hidden", to: value)
    }

    public func id(_ value: String) -> Attributes {
        set("id", to: value)
    }

    public func inert(_ value: String) -> Attributes {
        set("inert", to: value)
    }

    public func inputmode(_ value: String) -> Attributes {
        set("inputmode", to: value)
    }

    public func `is`(_ value: String) -> Attributes {
        set("is", to: value)
    }

    public func itemid(_ value: String) -> Attributes {
        set("itemid", to: value)
    }

    public func itemprop(_ value: String) -> Attributes {
        set("itemprop", to: value)
    }

    public func itemref(_ value: String) -> Attributes {
        set("itemref", to: value)
    }

    public func itemscope(_ value: String) -> Attributes {
        set("itemscope", to: value)
    }

    public func itemtype(_ value: String) -> Attributes {
        set("itemtype", to: value)
    }

    public func lang(_ value: String) -> Attributes {
        set("lang", to: value)
    }

    public func nonce(_ value: String) -> Attributes {
        set("nonce", to: value)
    }

    public func popover(_ value: String) -> Attributes {
        set("popover", to: value)
    }

    public func slot(_ value: String) -> Attributes {
        set("slot", to: value)
    }

    public func spellcheck(_ value: String) -> Attributes {
        set("spellcheck", to: value)
    }

    public func style(_ value: String) -> Attributes {
        set("style", to: value)
    }

    public func tabindex(_ value: String) -> Attributes {
        set("tabindex", to: value)
    }

    public func title(_ value: String) -> Attributes {
        set("title", to: value)
    }

    public func translate(_ value: String) -> Attributes {
        set("translate", to: value)
    }

    public func writingsuggestions(_ value: String) -> Attributes {
        set("writingsuggestions", to: value)
    }

    public func charset(_ value: String) -> Attributes {
        set("charset", to: value)
    }

    public func coords(_ value: String) -> Attributes {
        set("coords", to: value)
    }

    public func download(_ value: String) -> Attributes {
        set("download", to: value)
    }

    public func href(_ value: String) -> Attributes {
        set("href", to: value)
    }

    public func hreflang(_ value: String) -> Attributes {
        set("hreflang", to: value)
    }

    public func name(_ value: String) -> Attributes {
        set("name", to: value)
    }

    public func ping(_ value: String) -> Attributes {
        set("ping", to: value)
    }

    public func referrerpolicy(_ value: String) -> Attributes {
        set("referrerpolicy", to: value)
    }

    public func rel(_ value: String) -> Attributes {
        set("rel", to: value)
    }

    public func rev(_ value: String) -> Attributes {
        set("rev", to: value)
    }

    public func shape(_ value: String) -> Attributes {
        set("shape", to: value)
    }

    public func target(_ value: String) -> Attributes {
        set("target", to: value)
    }

    public func type(_ value: String) -> Attributes {
        set("type", to: value)
    }

    public func align(_ value: String) -> Attributes {
        set("align", to: value)
    }

    public func alt(_ value: String) -> Attributes {
        set("alt", to: value)
    }

    public func archive(_ value: String) -> Attributes {
        set("archive", to: value)
    }

    public func code(_ value: String) -> Attributes {
        set("code", to: value)
    }

    public func codebase(_ value: String) -> Attributes {
        set("codebase", to: value)
    }

    public func height(_ value: String) -> Attributes {
        set("height", to: value)
    }

    public func hspace(_ value: String) -> Attributes {
        set("hspace", to: value)
    }

    public func object(_ value: String) -> Attributes {
        set("object", to: value)
    }

    public func vspace(_ value: String) -> Attributes {
        set("vspace", to: value)
    }

    public func width(_ value: String) -> Attributes {
        set("width", to: value)
    }

    public func nohref(_ value: String) -> Attributes {
        set("nohref", to: value)
    }

    public func autoplay(_ value: String) -> Attributes {
        set("autoplay", to: value)
    }

    public func controls(_ value: String) -> Attributes {
        set("controls", to: value)
    }

    public func crossorigin(_ value: String) -> Attributes {
        set("crossorigin", to: value)
    }

    public func loop(_ value: String) -> Attributes {
        set("loop", to: value)
    }

    public func muted(_ value: String) -> Attributes {
        set("muted", to: value)
    }

    public func preload(_ value: String) -> Attributes {
        set("preload", to: value)
    }

    public func src(_ value: String) -> Attributes {
        set("src", to: value)
    }

    public func color(_ value: String) -> Attributes {
        set("color", to: value)
    }

    public func face(_ value: String) -> Attributes {
        set("face", to: value)
    }

    public func size(_ value: String) -> Attributes {
        set("size", to: value)
    }

    public func cite(_ value: String) -> Attributes {
        set("cite", to: value)
    }

    public func alink(_ value: String) -> Attributes {
        set("alink", to: value)
    }

    public func background(_ value: String) -> Attributes {
        set("background", to: value)
    }

    public func bgcolor(_ value: String) -> Attributes {
        set("bgcolor", to: value)
    }

    public func link(_ value: String) -> Attributes {
        set("link", to: value)
    }

    public func text(_ value: String) -> Attributes {
        set("text", to: value)
    }

    public func vlink(_ value: String) -> Attributes {
        set("vlink", to: value)
    }

    public func clear(_ value: String) -> Attributes {
        set("clear", to: value)
    }

    public func disabled(_ value: String) -> Attributes {
        set("disabled", to: value)
    }

    public func form(_ value: String) -> Attributes {
        set("form", to: value)
    }

    public func formaction(_ value: String) -> Attributes {
        set("formaction", to: value)
    }

    public func formenctype(_ value: String) -> Attributes {
        set("formenctype", to: value)
    }

    public func formmethod(_ value: String) -> Attributes {
        set("formmethod", to: value)
    }

    public func formnovalidate(_ value: String) -> Attributes {
        set("formnovalidate", to: value)
    }

    public func formtarget(_ value: String) -> Attributes {
        set("formtarget", to: value)
    }

    public func popovertarget(_ value: String) -> Attributes {
        set("popovertarget", to: value)
    }

    public func popovertargetaction(_ value: String) -> Attributes {
        set("popovertargetaction", to: value)
    }

    public func value(_ value: String) -> Attributes {
        set("value", to: value)
    }

    public func char(_ value: String) -> Attributes {
        set("char", to: value)
    }

    public func charoff(_ value: String) -> Attributes {
        set("charoff", to: value)
    }

    public func span(_ value: String) -> Attributes {
        set("span", to: value)
    }

    public func valign(_ value: String) -> Attributes {
        set("valign", to: value)
    }

    public func datetime(_ value: String) -> Attributes {
        set("datetime", to: value)
    }

    public func open(_ value: String) -> Attributes {
        set("open", to: value)
    }

    public func compact(_ value: String) -> Attributes {
        set("compact", to: value)
    }

    public func accept(_ value: String) -> Attributes {
        set("accept", to: value)
    }

    public func acceptCharset(_ value: String) -> Attributes {
        set("accept-charset", to: value)
    }

    public func action(_ value: String) -> Attributes {
        set("action", to: value)
    }

    public func autocomplete(_ value: String) -> Attributes {
        set("autocomplete", to: value)
    }

    public func enctype(_ value: String) -> Attributes {
        set("enctype", to: value)
    }

    public func method(_ value: String) -> Attributes {
        set("method", to: value)
    }

    public func novalidate(_ value: String) -> Attributes {
        set("novalidate", to: value)
    }

    public func frameborder(_ value: String) -> Attributes {
        set("frameborder", to: value)
    }

    public func longdesc(_ value: String) -> Attributes {
        set("longdesc", to: value)
    }

    public func marginheight(_ value: String) -> Attributes {
        set("marginheight", to: value)
    }

    public func marginwidth(_ value: String) -> Attributes {
        set("marginwidth", to: value)
    }

    public func noresize(_ value: String) -> Attributes {
        set("noresize", to: value)
    }

    public func scrolling(_ value: String) -> Attributes {
        set("scrolling", to: value)
    }

    public func cols(_ value: String) -> Attributes {
        set("cols", to: value)
    }

    public func rows(_ value: String) -> Attributes {
        set("rows", to: value)
    }

    public func profile(_ value: String) -> Attributes {
        set("profile", to: value)
    }

    public func noshade(_ value: String) -> Attributes {
        set("noshade", to: value)
    }

    public func manifest(_ value: String) -> Attributes {
        set("manifest", to: value)
    }

    public func version(_ value: String) -> Attributes {
        set("version", to: value)
    }

    public func allow(_ value: String) -> Attributes {
        set("allow", to: value)
    }

    public func allowfullscreen(_ value: String) -> Attributes {
        set("allowfullscreen", to: value)
    }

    public func allowpaymentrequest(_ value: String) -> Attributes {
        set("allowpaymentrequest", to: value)
    }

    public func allowusermedia(_ value: String) -> Attributes {
        set("allowusermedia", to: value)
    }

    public func loading(_ value: String) -> Attributes {
        set("loading", to: value)
    }

    public func sandbox(_ value: String) -> Attributes {
        set("sandbox", to: value)
    }

    public func srcdoc(_ value: String) -> Attributes {
        set("srcdoc", to: value)
    }

    public func border(_ value: String) -> Attributes {
        set("border", to: value)
    }

    public func decoding(_ value: String) -> Attributes {
        set("decoding", to: value)
    }

    public func fetchpriority(_ value: String) -> Attributes {
        set("fetchpriority", to: value)
    }

    public func ismap(_ value: String) -> Attributes {
        set("ismap", to: value)
    }

    public func sizes(_ value: String) -> Attributes {
        set("sizes", to: value)
    }

    public func srcset(_ value: String) -> Attributes {
        set("srcset", to: value)
    }

    public func usemap(_ value: String) -> Attributes {
        set("usemap", to: value)
    }

    public func checked(_ value: String) -> Attributes {
        set("checked", to: value)
    }

    public func dirname(_ value: String) -> Attributes {
        set("dirname", to: value)
    }

    public func list(_ value: String) -> Attributes {
        set("list", to: value)
    }

    public func max(_ value: String) -> Attributes {
        set("max", to: value)
    }

    public func maxlength(_ value: String) -> Attributes {
        set("maxlength", to: value)
    }

    public func min(_ value: String) -> Attributes {
        set("min", to: value)
    }

    public func minlength(_ value: String) -> Attributes {
        set("minlength", to: value)
    }

    public func multiple(_ value: String) -> Attributes {
        set("multiple", to: value)
    }

    public func pattern(_ value: String) -> Attributes {
        set("pattern", to: value)
    }

    public func placeholder(_ value: String) -> Attributes {
        set("placeholder", to: value)
    }

    public func readonly(_ value: String) -> Attributes {
        set("readonly", to: value)
    }

    public func required(_ value: String) -> Attributes {
        set("required", to: value)
    }

    public func step(_ value: String) -> Attributes {
        set("step", to: value)
    }

    public func prompt(_ value: String) -> Attributes {
        set("prompt", to: value)
    }

    public func `for`(_ value: String) -> Attributes {
        set("for", to: value)
    }

    public func `as`(_ value: String) -> Attributes {
        set("as", to: value)
    }

    public func blocking(_ value: String) -> Attributes {
        set("blocking", to: value)
    }

    public func imagesizes(_ value: String) -> Attributes {
        set("imagesizes", to: value)
    }

    public func imagesrcset(_ value: String) -> Attributes {
        set("imagesrcset", to: value)
    }

    public func integrity(_ value: String) -> Attributes {
        set("integrity", to: value)
    }

    public func media(_ value: String) -> Attributes {
        set("media", to: value)
    }

    public func content(_ value: String) -> Attributes {
        set("content", to: value)
    }

    public func httpEquiv(_ value: String) -> Attributes {
        set("http-equiv", to: value)
    }

    public func scheme(_ value: String) -> Attributes {
        set("scheme", to: value)
    }

    public func high(_ value: String) -> Attributes {
        set("high", to: value)
    }

    public func low(_ value: String) -> Attributes {
        set("low", to: value)
    }

    public func optimum(_ value: String) -> Attributes {
        set("optimum", to: value)
    }

    public func classid(_ value: String) -> Attributes {
        set("classid", to: value)
    }

    public func codetype(_ value: String) -> Attributes {
        set("codetype", to: value)
    }

    public func data(_ value: String) -> Attributes {
        set("data", to: value)
    }

    public func declare(_ value: String) -> Attributes {
        set("declare", to: value)
    }

    public func standby(_ value: String) -> Attributes {
        set("standby", to: value)
    }

    public func typemustmatch(_ value: String) -> Attributes {
        set("typemustmatch", to: value)
    }

    public func reversed(_ value: String) -> Attributes {
        set("reversed", to: value)
    }

    public func start(_ value: String) -> Attributes {
        set("start", to: value)
    }

    public func label(_ value: String) -> Attributes {
        set("label", to: value)
    }

    public func selected(_ value: String) -> Attributes {
        set("selected", to: value)
    }

    public func valuetype(_ value: String) -> Attributes {
        set("valuetype", to: value)
    }

    public func async(_ value: String) -> Attributes {
        set("async", to: value)
    }

    public func `defer`(_ value: String) -> Attributes {
        set("defer", to: value)
    }

    public func language(_ value: String) -> Attributes {
        set("language", to: value)
    }

    public func nomodule(_ value: String) -> Attributes {
        set("nomodule", to: value)
    }

    public func cellpadding(_ value: String) -> Attributes {
        set("cellpadding", to: value)
    }

    public func cellspacing(_ value: String) -> Attributes {
        set("cellspacing", to: value)
    }

    public func frame(_ value: String) -> Attributes {
        set("frame", to: value)
    }

    public func rules(_ value: String) -> Attributes {
        set("rules", to: value)
    }

    public func summary(_ value: String) -> Attributes {
        set("summary", to: value)
    }

    public func abbr(_ value: String) -> Attributes {
        set("abbr", to: value)
    }

    public func axis(_ value: String) -> Attributes {
        set("axis", to: value)
    }

    public func colspan(_ value: String) -> Attributes {
        set("colspan", to: value)
    }

    public func headers(_ value: String) -> Attributes {
        set("headers", to: value)
    }

    public func nowrap(_ value: String) -> Attributes {
        set("nowrap", to: value)
    }

    public func rowspan(_ value: String) -> Attributes {
        set("rowspan", to: value)
    }

    public func scope(_ value: String) -> Attributes {
        set("scope", to: value)
    }

    public func shadowrootclonable(_ value: String) -> Attributes {
        set("shadowrootclonable", to: value)
    }

    public func shadowrootdelegatesfocus(_ value: String) -> Attributes {
        set("shadowrootdelegatesfocus", to: value)
    }

    public func shadowrootmode(_ value: String) -> Attributes {
        set("shadowrootmode", to: value)
    }

    public func wrap(_ value: String) -> Attributes {
        set("wrap", to: value)
    }

    public func `default`(_ value: String) -> Attributes {
        set("default", to: value)
    }

    public func kind(_ value: String) -> Attributes {
        set("kind", to: value)
    }

    public func srclang(_ value: String) -> Attributes {
        set("srclang", to: value)
    }

    public func playsinline(_ value: String) -> Attributes {
        set("playsinline", to: value)
    }

    public func poster(_ value: String) -> Attributes {
        set("poster", to: value)
    }
    // @end
}
