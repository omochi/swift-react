import React
import JavaScriptKit
import SRTDOM
import BRTSupport

// https://ja.react.dev/learn/tutorial-tic-tac-toe

struct Square: Component {
    func render() -> Node {
        Fragment {
            button(
                attributes: [
                    "class": "square"
                ]
            ) {
                "X"
            }
            button(
                attributes: [
                    "class": "square"
                ]
            ) {
                "X"
            }
        }
    }
}

try addCSS(path: "BrowserTests_TicTacToe.resources/styles.css")
try renderRoot(component: Square())


