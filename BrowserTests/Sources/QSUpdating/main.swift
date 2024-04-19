import React
import JavaScriptKit
import SRTDOM
import BRTSupport

// https://ja.react.dev/learn#responding-to-events

struct MyButton: Component {
    @State var count = 0

    func render() -> Node {
        let handleClick = Function<Void, JSEvent> { (_) in
            count += 1
        }

        return button(
            listeners: [
                "click": handleClick
            ]
        ) {
            "Clicked \(count) times"
        }
    }
}

struct MyApp: Component {
    func render() -> Node {
        div {
            h1 { "Counters that update separately" }
            MyButton()
            MyButton()
        }
    }
}

try addCSS(path: "/Sources/QSUpdating/styles.css")
try renderRoot(component: MyApp())


