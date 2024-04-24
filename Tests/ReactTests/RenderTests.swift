import XCTest
import SRTTestSupport
import SRTDOM
import React

final class RenderTests: XCTestCase {
    override func setUp() {
        WebWindow.initializeJavaScriptKit()
        document = JSWindow.global.document
    }

    var document: JSDocument!

    func testCreate() throws {
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

    func testSingleTagComponent() throws {
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

    func testGroup1() throws {
        let dom = try document.createElement("body")
        let root = ReactRoot(element: dom)
        root.render(
            node: [
                h1(),
                h2()
            ]
        )
        XCTAssertPrint(dom, """
        <body>
            <h1 />
            <h2 />
        </body>
        """)
    }

    func testGroup2() throws {
        let dom = try document.createElement("body")
        let root = ReactRoot(element: dom)
        root.render(
            node: [
                h2(),
                h4(),
                h3()
            ]
        )
        XCTAssertPrint(dom, """
        <body>
            <h2 />
            <h4 />
            <h3 />
        </body>
        """)

        root.render(
            node: [
                h1(),
                h3(),
                h4()
            ]
        )
        XCTAssertPrint(dom, """
        <body>
            <h1 />
            <h3 />
            <h4 />
        </body>
        """)
    }

    func testTree1() throws {
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

    func testRootText() throws {
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

    func testComplexComponent() throws {
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

    func testAttribute() throws {
        let dom = try document.createElement("body")
        let root = ReactRoot(element: dom)
        root.render(node: div(attributes: ["class": "box"]))
        XCTAssertPrint(dom, """
        <body>
            <div class="box" />
        </body>
        """)
    }

    func testUpdateAttribute() throws {
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

    func testEventListener() throws {
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
                .find { $0.htmlElement?.tagName == "div" }?
                .instance?.dom?.asHTMLElement()
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
                .find { $0.htmlElement?.tagName == "div" }?
                .instance?.dom?.asHTMLElement()
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
                .find { $0.htmlElement?.tagName == "div" }?
                .instance?.dom?.asHTMLElement()
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

    func testSimpleStaticNodeArray() throws {
        struct Paragraph: Component {
            func render() -> Node {
                div(attributes: ["class": "para"])
            }
        }

        let body = try document.createElement("body")
        let root = ReactRoot(element: body)

        root.render(
            node: [
                Paragraph(),
                div()
            ]
        )

        XCTAssertPrint(root.dom, """
        <body>
            <div class="para" />
            <div />
        </body>
        """)
    }

    func testStaticNodeArray() throws {
        struct Paragraph: Component {
            func render() -> Node {
                div(attributes: ["class": "para"])
            }
        }

        struct ArraySection: Component {
            func render() -> Node {
                [
                    Paragraph(),
                    div(attributes: ["class": "array"])
                ]
            }
        }

        struct FragmentSection: Component {
            func render() -> Node {
                Fragment {
                    Paragraph()
                    div(attributes: ["class": "frag"])
                }
            }
        }

        let body = try document.createElement("body")
        let root = ReactRoot(element: body)

        root.render(
            node: [
                FragmentSection(),
                ArraySection()
            ]
        )

        XCTAssertPrint(root.dom, """
        <body>
            <div class="para" />
            <div class="frag" />
            <div class="para" />
            <div class="array" />
        </body>
        """)
    }

    func testDynamicNodeArray() throws {
        struct Content: Component {
            var ids: [Int]

            func render() -> Node {
                ids.map { (id) in
                    div {
                        "\(id)"
                    }
                }
            }
        }

        let body = try document.createElement("body")
        let root = ReactRoot(element: body)
        root.render(node: Content(ids: [1, 2, 3]))
        XCTAssertPrint(root.dom, """
        <body>
            <div>
                1
            </div>
            <div>
                2
            </div>
            <div>
                3
            </div>
        </body>
        """)
        root.render(node: Content(ids: [4, 5]))
        XCTAssertPrint(root.dom, """
        <body>
            <div>
                4
            </div>
            <div>
                5
            </div>
        </body>
        """)
    }


    func testFragmentDynamicNodeArray() throws {
        struct Content: Component {
            var ids: [Int]

            func render() -> Node {
                Fragment {
                    ids.map { (id) in
                        div {
                            "\(id)"
                        }
                    }
                }
            }
        }

        let body = try document.createElement("body")
        let root = ReactRoot(element: body)
        root.render(node: Content(ids: [1, 2, 3]))
        XCTAssertPrint(root.dom, """
        <body>
            <div>
                1
            </div>
            <div>
                2
            </div>
            <div>
                3
            </div>
        </body>
        """)
        root.render(node: Content(ids: [4, 5]))
        XCTAssertPrint(root.dom, """
        <body>
            <div>
                4
            </div>
            <div>
                5
            </div>
        </body>
        """)
    }
}
