import React
import JavaScriptKit
import SRTDOM
import BRTSupport

// https://ja.react.dev/learn#conditional-rendering

struct AdminPanel: Component {
    func render() -> Node {
        div {
            "AdminPanel"
        }
    }
}

struct LoginForm: Component {
    func render() -> Node {
        div {
            "LoginForm"
        }
    }
}

struct Cond0: Component {
    var isLoggedIn: Bool
    func render() -> Node {
        let content: any Component

        if isLoggedIn {
            content = AdminPanel()
        } else {
            content = LoginForm()
        }

        return div {
            content
        }
    }
}

struct Cond1: Component {
    var isLoggedIn: Bool
    func render() -> Node {
        return div {
            if isLoggedIn {
                AdminPanel()
            } else {
                LoginForm()
            }
        }
    }
}

struct Cond2: Component {
    var isLoggedIn: Bool
    func render() -> Node {
        return div {
            isLoggedIn ? 
            AdminPanel() :
            LoginForm() as any Component
        }
    }
}

struct Cond3: Component {
    var isLoggedIn: Bool
    func render() -> Node {
        return div {
            if isLoggedIn { AdminPanel() }
        }
    }
}

struct Content: Component {
    func render() -> Node {
        Fragment {
            "cond0 false"
            Cond0(isLoggedIn: false)
            "cond0 true"
            Cond0(isLoggedIn: true)

            "cond1 false"
            Cond1(isLoggedIn: false)
            "cond1 true"
            Cond1(isLoggedIn: true)

            "cond2 false"
            Cond2(isLoggedIn: false)
            "cond2 true"
            Cond2(isLoggedIn: true)

            "cond3 false"
            Cond3(isLoggedIn: false)
            "cond3 true"
            Cond3(isLoggedIn: true)
        }
    }
}

let g = JSWindow.global

let body = try g.document.body.unwrap("body")
let root = ReactRoot(element: body)
root.render(node: Content())
