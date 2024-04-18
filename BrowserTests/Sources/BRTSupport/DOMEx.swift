import JavaScriptKit
import SRTDOM

extension JSHTMLElement {
    public func setAttributes(_ attributes: [String: String]) throws {
        for (k, v) in attributes {
            try setAttribute(k, v)
        }
    }
}
