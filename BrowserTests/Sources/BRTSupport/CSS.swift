import JavaScriptKit
import SRTDOM

extension JSDocument {
    public func addCSS(path: String) throws {
        let head = try self.querySelector("head").unwrap("head")

        let tag = try self.createElement("link")
        try tag.setAttributes([
            "rel": "stylesheet",
            "type": "text/css",
            "href": path
        ])
        try head.appendChild(tag)
    }
}
