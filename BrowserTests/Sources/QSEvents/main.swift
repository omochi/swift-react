import React
import JavaScriptKit
import SRTDOM
import BRTSupport

// https://ja.react.dev/learn#responding-to-events

struct MyButton: Component {
    func render() -> Node {
        let handleClick = Function<Void, JSEvent> { (_) in
            do {
                try JSWindow.global.alert("You clicked me!")
            } catch {
                print(error)
            }
        }

        return button(
            listeners: [
                "click": handleClick
            ]
        ) {
            "Click me"
        }
    }
}

try renderRoot(component: MyButton())


