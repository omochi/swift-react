import XCTest
import SRTTestSupport
import DOMModule
import React

final class RenderTests: XCTestCase {
    struct AView: Component {
        func render() -> Node {
            div()
        }
    }

    func testRender1() {
        let dom = DOMTagNode(tagName: "body")
        XCTAssertPrint(dom, """
        <body />
        """)

        let root = ReactRoot(element: dom)
        root.render(node: div())
        XCTAssertPrint(dom, """
        <body>
            <div />
        </body>
        """)

        root.render(node: nil)
        XCTAssertPrint(dom, """
        <body />
        """)

        root.render(node: AView())
        XCTAssertPrint(dom, """
        <body>
            <div />
        </body>
        """)
    }

    func testRender2() {
        let dom = DOMTagNode(tagName: "body")
        let root = ReactRoot(element: dom)
        root.render(node: div())
        XCTAssertPrint(dom, """
        <body>
            <div />
        </body>
        """)

        root.render(node: div(.init(["class": "box"])))
        XCTAssertPrint(dom, """
        <body>
            <div class="box" />
        </body>
        """)
    }

    func testRenderGroup1() {
        let dom = DOMTagNode(tagName: "body")
        let root = ReactRoot(element: dom)
        root.render(
            node: NodeCollection(
                h1(),
                h2()
            )
        )
        XCTAssertPrint(dom, """
        <body>
            <h1 />
            <h2 />
        </body>
        """)
    }

    func testRenderGroup2() {
        let dom = DOMTagNode(tagName: "body")
        let root = ReactRoot(element: dom)
        root.render(
            node: NodeCollection(
                h2(),
                h4(),
                h3()
            )
        )
        XCTAssertPrint(dom, """
        <body>
            <h2 />
            <h4 />
            <h3 />
        </body>
        """)

        root.render(
            node: NodeCollection(
                h1(),
                h3(),
                h4()
            )
        )
        XCTAssertPrint(dom, """
        <body>
            <h1 />
            <h3 />
            <h4 />
        </body>
        """)
    }

    func testRenderTree1() {
        let dom = DOMTagNode(tagName: "body")
        let root = ReactRoot(element: dom)
        root.render(
            node: div {
                div {
                    h1()
                    p()
                }
            }
        )
        XCTAssertPrint(dom, """
        <body>
            <div>
                <div>
                    <h1 />
                    <p />
                </div>
            </div>
        </body>
        """)

        root.render(
            node: div {
                div {
                    h2()
                    p()
                }
                div {
                    p()
                }
            }
        )
        XCTAssertPrint(dom, """
        <body>
            <div>
                <div>
                    <h2 />
                    <p />
                </div>
                <div>
                    <p />
                </div>
            </div>
        </body>
        """)
    }

    struct MyApp: Component {
        func render() -> Node {
            div {
//                h1 { "Hello My App" }
//                p { "hello" }
                button()
            }
        }
    }
}
