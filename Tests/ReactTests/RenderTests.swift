import XCTest
import SRTJavaScriptKitEx
import SRTTestSupport
import SRTDOM
import React

final class RenderTests: XCTestCase {
    override func setUp() {
        WebWindow.initializeJavaScriptKit()
        document = JSWindow.global.document
    }

    var document: JSDocument!

    func testRenderCreate() throws {
        let dom = try document.createElement("body")
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

    func testRenderSingleTagComponent() throws {
        struct Content: Component {
            func render() -> Node {
                div()
            }
        }

        let dom = try document.createElement("body")
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

    func testRenderGroup1() throws {
        let dom = try document.createElement("body")
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

    func testRenderGroup2() throws {
        let dom = try document.createElement("body")
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

    func testRenderTree1() throws {
        let dom = try document.createElement("body")
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

    func testRenderRootText() throws {
        let dom = try document.createElement("body")
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

    func testRenderComplexComponent() throws {
        struct Content: Component {
            func render() -> Node {
                div {
                    h1 { "hello world" }
                    button { "submit" }
                }
            }
        }

        let dom = try document.createElement("body")
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

    func testRenderAttribute() throws {
        let dom = try document.createElement("body")
        let root = ReactRoot(element: dom)
        root.render(node: div(attributes: ["class": "box"]))
        XCTAssertPrint(dom, """
        <body>
            <div class="box" />
        </body>
        """)
    }

    func testRenderUpdateAttribute() throws {
        let dom = try document.createElement("body")
        let root = ReactRoot(element: dom)
        root.render(node: div())
        XCTAssertPrint(dom, """
        <body>
            <div />
        </body>
        """)

        root.render(node: div(attributes: ["class": "box"]))
        XCTAssertPrint(dom, """
        <body>
            <div class="box" />
        </body>
        """)
    }

    func testRenderEventListener() throws {
        let body = try document.createElement("body")
        let root = ReactRoot(element: body)

        var evs0: [JSEvent] = []
        let ln0 = EventListener { (ev) in
            evs0.append(ev)
        }

        root.render(
            node: div(
                listeners: [
                    "click": ln0
                ]
            )
        )

        let divDom0: JSHTMLElement = try XCTUnwrap(
            root.root?
                .find { $0.tagElement?.tagName == "div" }?
                .dom?.asHTMLElement()
        )
        
        let MouseEvent = JSWindow.global.MouseEvent
        let ev0 = try MouseEvent.new("click")
        try divDom0.dispatchEvent(ev0)

        XCTAssertEqual(evs0.count, 1)
        XCTAssertEqual(evs0[safe: 0], ev0.asEvent())

        var evs1: [JSEvent] = []
        let ln1 = EventListener { (ev) in
            evs1.append(ev)
        }

        root.render(
            node: div(
                listeners: [
                    "click": ln1
                ]
            )
        )

        // update check
        let divDom1: JSHTMLElement = try XCTUnwrap(
            root.root?
                .find { $0.tagElement?.tagName == "div" }?
                .dom?.asHTMLElement()
        )
        XCTAssertEqual(divDom0, divDom1)
        _ = consume divDom1

        let ev1 = try MouseEvent.new("click")
        try divDom0.dispatchEvent(ev1)

        // dont change
        XCTAssertEqual(evs0.count, 1)
        XCTAssertEqual(evs0[safe: 0], ev0.asEvent())

        // added
        XCTAssertEqual(evs1.count, 1)
        XCTAssertEqual(evs1[safe: 0], ev1.asEvent())

        root.render(
            node: div()
        )
        // update check
        let divDom2: JSHTMLElement = try XCTUnwrap(
            root.root?
                .find { $0.tagElement?.tagName == "div" }?
                .dom?.asHTMLElement()
        )
        XCTAssertEqual(divDom0, divDom2)
        _ = consume divDom2

        let ev2 = try MouseEvent.new("click")
        try divDom0.dispatchEvent(ev2)

        // dont change
        XCTAssertEqual(evs0.count, 1)
        XCTAssertEqual(evs0[safe: 0], ev0.asEvent())

        // dont change
        XCTAssertEqual(evs1.count, 1)
        XCTAssertEqual(evs1[safe: 0], ev1.asEvent())
    }

    func testRenderRef() throws {
        struct Content: Component {
            @Ref var buttonRef: JSHTMLElement?
            var renderHook: Function<Void, Content>

            func render() -> Node {
                renderHook(self)
                return div {
                    button(ref: $buttonRef) { "hi" }
                }
            }
        }

        var refs: [JSHTMLElement?] = []

        let body = try document.createElement("body")
        let root = ReactRoot(element: body)
        root.render(
            node: Content(
                renderHook: Function { (content) in
                    refs.append(content.buttonRef)
                }
            )
        )

        XCTAssertEqual(refs.count, 1)
        XCTAssertEqual(refs[safe: 0], .some(nil))

        root.render(
            node: Content(
                renderHook: Function { (content) in
                    refs.append(content.buttonRef)
                }
            )
        )

        let btn: JSHTMLElement = try XCTUnwrap(
            root.root?
                .find { $0.tagElement?.tagName == "button" }?
                .dom?.asHTMLElement()
        )

        XCTAssertEqual(refs.count, 2)
        XCTAssertEqual(refs[safe: 1], btn)
    }
}
