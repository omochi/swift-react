import JavaScriptKit
import SRTDOM

public func addCSS(path: String) throws {
    let document = JSWindow.global.document

    let head = try document.querySelector("head").unwrap("head")

    let tag = try document.createElement("link")
    try tag.setAttributes([
        "rel": "stylesheet",
        "type": "text/css",
        "href": path
    ])
    try head.appendChild(tag)
}
