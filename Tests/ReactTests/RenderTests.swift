import XCTest
import SRTTestSupport
import SRTDOM
import JavaScriptKitShim
import React
#if USES_JAVASCRIPT_KIT_MOCK
import WebMock
#endif

final class RenderTests: XCTestCase {
    override func setUp() {
#if USES_JAVASCRIPT_KIT_MOCK
        WebWindow.initializeJavaScriptKit()
#endif

        document = JSWindow.global.document
    }

    var document: JSDocument!

    func testRenderCreate() {
        let dom = document.createElement("body")
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
    }

    func testRenderSingleTagComponent() {
        struct Content: Component {
            func render() -> Node {
                div()
            }
        }

        let dom = document.createElement("body")
        XCTAssertPrint(dom, """
        <body />
        """)

        let root = ReactRoot(element: dom)
        root.render(node: Content())
        XCTAssertPrint(dom, """
        <body>
            <div />
        </body>
        """)
    }

    func testRenderGroup1() {
        let dom = document.createElement("body")
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
        let dom = document.createElement("body")
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
        let dom = document.createElement("body")
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

    func testRenderRootText() {
        let dom = document.createElement("body")
        let root = ReactRoot(element: dom)
        root.render(
            node: "hello"
        )

        XCTAssertPrint(dom, """
        <body>
            hello
        </body>
        """)
    }

    func testRenderComplexComponent() {
        struct Content: Component {
            func render() -> Node {
                div {
                    h1 { "hello world" }
                    button { "submit" }
                }
            }
        }

        let dom = document.createElement("body")
        XCTAssertPrint(dom, """
        <body />
        """)

        let root = ReactRoot(element: dom)
        root.render(node: Content())
        XCTAssertPrint(dom, """
        <body>
            <div>
                <h1>
                    hello world
                </h1>
                <button>
                    submit
                </button>
            </div>
        </body>
        """)
    }

    func testRenderAttribute() {
        let dom = document.createElement("body")
        let root = ReactRoot(element: dom)
        root.render(node: div(["class": "box"]))
        XCTAssertPrint(dom, """
        <body>
            <div class="box" />
        </body>
        """)
    }

    func testRenderUpdateAttribute() {
        let dom = document.createElement("body")
        let root = ReactRoot(element: dom)
        root.render(node: div())
        XCTAssertPrint(dom, """
        <body>
            <div />
        </body>
        """)

        root.render(node: div(["class": "box"]))
        XCTAssertPrint(dom, """
        <body>
            <div class="box" />
        </body>
        """)
    }
}
