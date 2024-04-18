import React
import JavaScriptKit
import SRTDOM
import BRTSupport

// https://ja.react.dev/learn#writing-markup-with-jsx

struct User {
    var name: String = "Hedy Lamarr"
    var imageUrl: String = "https://i.imgur.com/yXOvdOSs.jpg"
    var imageSize: Int = 90
}

struct Profile: Component {
    var user: User = User()

    func render() -> Node {
        Fragment {
            h1 { user.name }
            img(
                attributes: [
                    "class": "avatar",
                    "src": user.imageUrl,
                    "alt": "Photo of " + user.name,
                    "style": """
                        width: \(user.imageSize)px;
                        height: \(user.imageSize)px;
                    """
                ]
            )
        }
    }
}

try addCSS(path: "/Sources/QSDisplayingData/styles.css")
try renderRoot(component: Profile())
