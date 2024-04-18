import React
import JavaScriptKit
import SRTDOM
import BRTSupport

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

try renderRoot(component: AboutPage())
