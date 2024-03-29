import Collections
import DOMModule

public struct TagAttributes {
    public init() {}

    public init(build: (inout TagAttributes) -> Void) {
        self.init()
        build(&self)
    }

    package var values: OrderedDictionary<String, Any> = [:]
}

extension TagAttributes {
    public var `class`: String? {
        get { values["class"] as? String }
        set { values["class"] = newValue }
    }

    public var `onclick`: DOMEventHandler? {
        get { values["onclick"] as? DOMEventHandler }
        set { values["onclick"] = newValue }
    }
}
