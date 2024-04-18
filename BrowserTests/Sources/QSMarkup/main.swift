import React
import JavaScriptKit
import SRTDOM

// https://ja.react.dev/learn#writing-markup-with-jsx

struct AboutPage: Component {
    func render() -> Node {
        return Fragment {
            h1 { "About" }
            p {
                "Hello there."
                br()
                "How do you do?"
            }
        }
    }
}

let body = try JSWindow.global.document.body.unwrap("body")
let root = ReactRoot(element: body)
root.render(node: AboutPage())
