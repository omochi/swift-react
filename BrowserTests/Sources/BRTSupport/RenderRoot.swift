import React
import JavaScriptKit
import SRTDOM

public func renderRoot(component: some Component) throws {
    let body = try JSWindow.global.document.body.unwrap("body")
    let root = ReactRoot(element: body)
    root.render(node: component)
}
