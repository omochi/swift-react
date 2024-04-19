import React
import JavaScriptKit
import SRTDOM
import BRTSupport

// https://ja.react.dev/learn#sharing-data-between-components

struct MyButton: Component {
    var count: Int
    var onClick: EventListener

    func render() -> Node {
        return button(
            listeners: [
                "click": onClick
            ]
        ) {
            "Clicked \(count) times"
        }
    }
}

struct MyApp: Component {
    @State var count = 0

    func render() -> Node {
        let handleClick = EventListener { (_) in
            count += 1
        }

        return div {
            h1 { "Counters that update together" }
            MyButton(count: count, onClick: handleClick)
            MyButton(count: count, onClick: handleClick)
        }
    }
}

try addCSS(path: "/Sources/QSSharing/styles.css")
try renderRoot(component: MyApp())


