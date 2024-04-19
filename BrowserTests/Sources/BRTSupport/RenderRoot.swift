import React
import JavaScriptKit
import SRTDOM

public var root: ReactRoot? = nil

public func renderRoot(component: some Component) throws {
    let body = try JSWindow.global.document.body.unwrap("body")
    let root = ReactRoot(element: body)
    BRTSupport.root = root
    root.render(node: component)
}
