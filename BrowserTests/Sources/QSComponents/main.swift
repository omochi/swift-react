import React
import JavaScriptKit
import SRTDOM
import BRTSupport

// https://ja.react.dev/learn#components

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

try renderRoot(component: MyApp())
