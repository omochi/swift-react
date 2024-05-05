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
    public func accesskey(_ x: String) -> Attributes {
        set("accesskey", to: x)
    }

    public func autocapitalize(_ x: String) -> Attributes {
        set("autocapitalize", to: x)
    }

    public func autofocus(_ x: String) -> Attributes {
        set("autofocus", to: x)
    }

    public func `class`(_ x: String) -> Attributes {
        set("class", to: x)
    }

    public func contenteditable(_ x: String) -> Attributes {
        set("contenteditable", to: x)
    }

    public func dir(_ x: String) -> Attributes {
        set("dir", to: x)
    }

    public func draggable(_ x: String) -> Attributes {
        set("draggable", to: x)
    }

    public func enterkeyhint(_ x: String) -> Attributes {
        set("enterkeyhint", to: x)
    }

    public func hidden(_ x: String) -> Attributes {
        set("hidden", to: x)
    }

    public func id(_ x: String) -> Attributes {
        set("id", to: x)
    }

    public func inert(_ x: String) -> Attributes {
        set("inert", to: x)
    }

    public func inputmode(_ x: String) -> Attributes {
        set("inputmode", to: x)
    }

    public func `is`(_ x: String) -> Attributes {
        set("is", to: x)
    }

    public func itemid(_ x: String) -> Attributes {
        set("itemid", to: x)
    }

    public func itemprop(_ x: String) -> Attributes {
        set("itemprop", to: x)
    }

    public func itemref(_ x: String) -> Attributes {
        set("itemref", to: x)
    }

    public func itemscope(_ x: String) -> Attributes {
        set("itemscope", to: x)
    }

    public func itemtype(_ x: String) -> Attributes {
        set("itemtype", to: x)
    }

    public func lang(_ x: String) -> Attributes {
        set("lang", to: x)
    }

    public func nonce(_ x: String) -> Attributes {
        set("nonce", to: x)
    }

    public func popover(_ x: String) -> Attributes {
        set("popover", to: x)
    }

    public func slot(_ x: String) -> Attributes {
        set("slot", to: x)
    }

    public func spellcheck(_ x: String) -> Attributes {
        set("spellcheck", to: x)
    }

    public func style(_ x: String) -> Attributes {
        set("style", to: x)
    }

    public func tabindex(_ x: String) -> Attributes {
        set("tabindex", to: x)
    }

    public func title(_ x: String) -> Attributes {
        set("title", to: x)
    }

    public func translate(_ x: String) -> Attributes {
        set("translate", to: x)
    }

    public func writingsuggestions(_ x: String) -> Attributes {
        set("writingsuggestions", to: x)
    }

    public func charset(_ x: String) -> Attributes {
        set("charset", to: x)
    }

    public func coords(_ x: String) -> Attributes {
        set("coords", to: x)
    }

    public func download(_ x: String) -> Attributes {
        set("download", to: x)
    }

    public func href(_ x: String) -> Attributes {
        set("href", to: x)
    }

    public func hreflang(_ x: String) -> Attributes {
        set("hreflang", to: x)
    }

    public func name(_ x: String) -> Attributes {
        set("name", to: x)
    }

    public func ping(_ x: String) -> Attributes {
        set("ping", to: x)
    }

    public func referrerpolicy(_ x: String) -> Attributes {
        set("referrerpolicy", to: x)
    }

    public func rel(_ x: String) -> Attributes {
        set("rel", to: x)
    }

    public func rev(_ x: String) -> Attributes {
        set("rev", to: x)
    }

    public func shape(_ x: String) -> Attributes {
        set("shape", to: x)
    }

    public func target(_ x: String) -> Attributes {
        set("target", to: x)
    }

    public func type(_ x: String) -> Attributes {
        set("type", to: x)
    }

    public func align(_ x: String) -> Attributes {
        set("align", to: x)
    }

    public func alt(_ x: String) -> Attributes {
        set("alt", to: x)
    }

    public func archive(_ x: String) -> Attributes {
        set("archive", to: x)
    }

    public func code(_ x: String) -> Attributes {
        set("code", to: x)
    }

    public func codebase(_ x: String) -> Attributes {
        set("codebase", to: x)
    }

    public func height(_ x: String) -> Attributes {
        set("height", to: x)
    }

    public func hspace(_ x: String) -> Attributes {
        set("hspace", to: x)
    }

    public func object(_ x: String) -> Attributes {
        set("object", to: x)
    }

    public func vspace(_ x: String) -> Attributes {
        set("vspace", to: x)
    }

    public func width(_ x: String) -> Attributes {
        set("width", to: x)
    }

    public func nohref(_ x: String) -> Attributes {
        set("nohref", to: x)
    }

    public func autoplay(_ x: String) -> Attributes {
        set("autoplay", to: x)
    }

    public func controls(_ x: String) -> Attributes {
        set("controls", to: x)
    }

    public func crossorigin(_ x: String) -> Attributes {
        set("crossorigin", to: x)
    }

    public func loop(_ x: String) -> Attributes {
        set("loop", to: x)
    }

    public func muted(_ x: String) -> Attributes {
        set("muted", to: x)
    }

    public func preload(_ x: String) -> Attributes {
        set("preload", to: x)
    }

    public func src(_ x: String) -> Attributes {
        set("src", to: x)
    }

    public func color(_ x: String) -> Attributes {
        set("color", to: x)
    }

    public func face(_ x: String) -> Attributes {
        set("face", to: x)
    }

    public func size(_ x: String) -> Attributes {
        set("size", to: x)
    }

    public func cite(_ x: String) -> Attributes {
        set("cite", to: x)
    }

    public func alink(_ x: String) -> Attributes {
        set("alink", to: x)
    }

    public func background(_ x: String) -> Attributes {
        set("background", to: x)
    }

    public func bgcolor(_ x: String) -> Attributes {
        set("bgcolor", to: x)
    }

    public func link(_ x: String) -> Attributes {
        set("link", to: x)
    }

    public func text(_ x: String) -> Attributes {
        set("text", to: x)
    }

    public func vlink(_ x: String) -> Attributes {
        set("vlink", to: x)
    }

    public func clear(_ x: String) -> Attributes {
        set("clear", to: x)
    }

    public func disabled(_ x: String) -> Attributes {
        set("disabled", to: x)
    }

    public func form(_ x: String) -> Attributes {
        set("form", to: x)
    }

    public func formaction(_ x: String) -> Attributes {
        set("formaction", to: x)
    }

    public func formenctype(_ x: String) -> Attributes {
        set("formenctype", to: x)
    }

    public func formmethod(_ x: String) -> Attributes {
        set("formmethod", to: x)
    }

    public func formnovalidate(_ x: String) -> Attributes {
        set("formnovalidate", to: x)
    }

    public func formtarget(_ x: String) -> Attributes {
        set("formtarget", to: x)
    }

    public func popovertarget(_ x: String) -> Attributes {
        set("popovertarget", to: x)
    }

    public func popovertargetaction(_ x: String) -> Attributes {
        set("popovertargetaction", to: x)
    }

    public func value(_ x: String) -> Attributes {
        set("value", to: x)
    }

    public func char(_ x: String) -> Attributes {
        set("char", to: x)
    }

    public func charoff(_ x: String) -> Attributes {
        set("charoff", to: x)
    }

    public func span(_ x: String) -> Attributes {
        set("span", to: x)
    }

    public func valign(_ x: String) -> Attributes {
        set("valign", to: x)
    }

    public func datetime(_ x: String) -> Attributes {
        set("datetime", to: x)
    }

    public func open(_ x: String) -> Attributes {
        set("open", to: x)
    }

    public func compact(_ x: String) -> Attributes {
        set("compact", to: x)
    }

    public func accept(_ x: String) -> Attributes {
        set("accept", to: x)
    }

    public func acceptCharset(_ x: String) -> Attributes {
        set("accept-charset", to: x)
    }

    public func action(_ x: String) -> Attributes {
        set("action", to: x)
    }

    public func autocomplete(_ x: String) -> Attributes {
        set("autocomplete", to: x)
    }

    public func enctype(_ x: String) -> Attributes {
        set("enctype", to: x)
    }

    public func method(_ x: String) -> Attributes {
        set("method", to: x)
    }

    public func novalidate(_ x: String) -> Attributes {
        set("novalidate", to: x)
    }

    public func frameborder(_ x: String) -> Attributes {
        set("frameborder", to: x)
    }

    public func longdesc(_ x: String) -> Attributes {
        set("longdesc", to: x)
    }

    public func marginheight(_ x: String) -> Attributes {
        set("marginheight", to: x)
    }

    public func marginwidth(_ x: String) -> Attributes {
        set("marginwidth", to: x)
    }

    public func noresize(_ x: String) -> Attributes {
        set("noresize", to: x)
    }

    public func scrolling(_ x: String) -> Attributes {
        set("scrolling", to: x)
    }

    public func cols(_ x: String) -> Attributes {
        set("cols", to: x)
    }

    public func rows(_ x: String) -> Attributes {
        set("rows", to: x)
    }

    public func profile(_ x: String) -> Attributes {
        set("profile", to: x)
    }

    public func noshade(_ x: String) -> Attributes {
        set("noshade", to: x)
    }

    public func manifest(_ x: String) -> Attributes {
        set("manifest", to: x)
    }

    public func version(_ x: String) -> Attributes {
        set("version", to: x)
    }

    public func allow(_ x: String) -> Attributes {
        set("allow", to: x)
    }

    public func allowfullscreen(_ x: String) -> Attributes {
        set("allowfullscreen", to: x)
    }

    public func allowpaymentrequest(_ x: String) -> Attributes {
        set("allowpaymentrequest", to: x)
    }

    public func allowusermedia(_ x: String) -> Attributes {
        set("allowusermedia", to: x)
    }

    public func loading(_ x: String) -> Attributes {
        set("loading", to: x)
    }

    public func sandbox(_ x: String) -> Attributes {
        set("sandbox", to: x)
    }

    public func srcdoc(_ x: String) -> Attributes {
        set("srcdoc", to: x)
    }

    public func border(_ x: String) -> Attributes {
        set("border", to: x)
    }

    public func decoding(_ x: String) -> Attributes {
        set("decoding", to: x)
    }

    public func fetchpriority(_ x: String) -> Attributes {
        set("fetchpriority", to: x)
    }

    public func ismap(_ x: String) -> Attributes {
        set("ismap", to: x)
    }

    public func sizes(_ x: String) -> Attributes {
        set("sizes", to: x)
    }

    public func srcset(_ x: String) -> Attributes {
        set("srcset", to: x)
    }

    public func usemap(_ x: String) -> Attributes {
        set("usemap", to: x)
    }

    public func checked(_ x: String) -> Attributes {
        set("checked", to: x)
    }

    public func dirname(_ x: String) -> Attributes {
        set("dirname", to: x)
    }

    public func list(_ x: String) -> Attributes {
        set("list", to: x)
    }

    public func max(_ x: String) -> Attributes {
        set("max", to: x)
    }

    public func maxlength(_ x: String) -> Attributes {
        set("maxlength", to: x)
    }

    public func min(_ x: String) -> Attributes {
        set("min", to: x)
    }

    public func minlength(_ x: String) -> Attributes {
        set("minlength", to: x)
    }

    public func multiple(_ x: String) -> Attributes {
        set("multiple", to: x)
    }

    public func pattern(_ x: String) -> Attributes {
        set("pattern", to: x)
    }

    public func placeholder(_ x: String) -> Attributes {
        set("placeholder", to: x)
    }

    public func readonly(_ x: String) -> Attributes {
        set("readonly", to: x)
    }

    public func required(_ x: String) -> Attributes {
        set("required", to: x)
    }

    public func step(_ x: String) -> Attributes {
        set("step", to: x)
    }

    public func prompt(_ x: String) -> Attributes {
        set("prompt", to: x)
    }

    public func `for`(_ x: String) -> Attributes {
        set("for", to: x)
    }

    public func `as`(_ x: String) -> Attributes {
        set("as", to: x)
    }

    public func blocking(_ x: String) -> Attributes {
        set("blocking", to: x)
    }

    public func imagesizes(_ x: String) -> Attributes {
        set("imagesizes", to: x)
    }

    public func imagesrcset(_ x: String) -> Attributes {
        set("imagesrcset", to: x)
    }

    public func integrity(_ x: String) -> Attributes {
        set("integrity", to: x)
    }

    public func media(_ x: String) -> Attributes {
        set("media", to: x)
    }

    public func content(_ x: String) -> Attributes {
        set("content", to: x)
    }

    public func httpEquiv(_ x: String) -> Attributes {
        set("http-equiv", to: x)
    }

    public func scheme(_ x: String) -> Attributes {
        set("scheme", to: x)
    }

    public func high(_ x: String) -> Attributes {
        set("high", to: x)
    }

    public func low(_ x: String) -> Attributes {
        set("low", to: x)
    }

    public func optimum(_ x: String) -> Attributes {
        set("optimum", to: x)
    }

    public func classid(_ x: String) -> Attributes {
        set("classid", to: x)
    }

    public func codetype(_ x: String) -> Attributes {
        set("codetype", to: x)
    }

    public func data(_ x: String) -> Attributes {
        set("data", to: x)
    }

    public func declare(_ x: String) -> Attributes {
        set("declare", to: x)
    }

    public func standby(_ x: String) -> Attributes {
        set("standby", to: x)
    }

    public func typemustmatch(_ x: String) -> Attributes {
        set("typemustmatch", to: x)
    }

    public func reversed(_ x: String) -> Attributes {
        set("reversed", to: x)
    }

    public func start(_ x: String) -> Attributes {
        set("start", to: x)
    }

    public func label(_ x: String) -> Attributes {
        set("label", to: x)
    }

    public func selected(_ x: String) -> Attributes {
        set("selected", to: x)
    }

    public func valuetype(_ x: String) -> Attributes {
        set("valuetype", to: x)
    }

    public func async(_ x: String) -> Attributes {
        set("async", to: x)
    }

    public func `defer`(_ x: String) -> Attributes {
        set("defer", to: x)
    }

    public func language(_ x: String) -> Attributes {
        set("language", to: x)
    }

    public func nomodule(_ x: String) -> Attributes {
        set("nomodule", to: x)
    }

    public func cellpadding(_ x: String) -> Attributes {
        set("cellpadding", to: x)
    }

    public func cellspacing(_ x: String) -> Attributes {
        set("cellspacing", to: x)
    }

    public func frame(_ x: String) -> Attributes {
        set("frame", to: x)
    }

    public func rules(_ x: String) -> Attributes {
        set("rules", to: x)
    }

    public func summary(_ x: String) -> Attributes {
        set("summary", to: x)
    }

    public func abbr(_ x: String) -> Attributes {
        set("abbr", to: x)
    }

    public func axis(_ x: String) -> Attributes {
        set("axis", to: x)
    }

    public func colspan(_ x: String) -> Attributes {
        set("colspan", to: x)
    }

    public func headers(_ x: String) -> Attributes {
        set("headers", to: x)
    }

    public func nowrap(_ x: String) -> Attributes {
        set("nowrap", to: x)
    }

    public func rowspan(_ x: String) -> Attributes {
        set("rowspan", to: x)
    }

    public func scope(_ x: String) -> Attributes {
        set("scope", to: x)
    }

    public func shadowrootclonable(_ x: String) -> Attributes {
        set("shadowrootclonable", to: x)
    }

    public func shadowrootdelegatesfocus(_ x: String) -> Attributes {
        set("shadowrootdelegatesfocus", to: x)
    }

    public func shadowrootmode(_ x: String) -> Attributes {
        set("shadowrootmode", to: x)
    }

    public func wrap(_ x: String) -> Attributes {
        set("wrap", to: x)
    }

    public func `default`(_ x: String) -> Attributes {
        set("default", to: x)
    }

    public func kind(_ x: String) -> Attributes {
        set("kind", to: x)
    }

    public func srclang(_ x: String) -> Attributes {
        set("srclang", to: x)
    }

    public func playsinline(_ x: String) -> Attributes {
        set("playsinline", to: x)
    }

    public func poster(_ x: String) -> Attributes {
        set("poster", to: x)
    }
    // @end
}
