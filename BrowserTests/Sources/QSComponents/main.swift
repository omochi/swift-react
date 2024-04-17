import React
import SRTDOM
import JavaScriptKit

// https://ja.react.dev/learn

struct MyButton: Component {
    func render() -> Node {
        button {
            "I'm a button"
        }
    }
}

struct MyApp: Component {
    func render() -> Node {
        div {
            h1 {
                "Welcome to my app"
            }
            MyButton()
        }
    }
}

let body = try JSWindow.global.document.body.unwrap("body")
let root = ReactRoot(element: body)
root.render(node: MyApp())
