import XCTest
import SRTTestSupport
import SRTDOM
import React

final class ContextHookTests: XCTestCase {
    override func setUp() {
        WebWindow.initializeJavaScriptKit()
        document = JSWindow.global.document
    }

    var document: JSDocument!

    struct A: ContextValue {
        static var defaultValue: A { A(0) }
        init(_ value: Int) { self.value = value }
        var value: Int
    }

    struct B: ContextValue {
        static var defaultValue: B { B(0) }
        init(_ value: Int) { self.value = value }
        var value: Int
    }

    func testNoProvider() throws {
        struct Content: Component {
            @Context var a: A
            func render() -> Node {
                a.value
            }
        }

        let body = try document.createElement("body")
        let root = ReactRoot(element: body)
        let content = Content()
        root.render(node: content)

        XCTAssertPrint(body, """
        <body>
            0
        </body>
        """)
    }

    func testSingleProvider() throws {
        struct Content: Component {
            func render() -> Node {
                A.Provider(value: A(1)) {
                    Section()
                }
            }
        }

        struct Section: Component {
            @Context var a: A
            func render() -> Node {
                a.value
            }
        }

        let body = try document.createElement("body")
        let root = ReactRoot(element: body)
        let content = Content()
        root.render(node: content)

        XCTAssertPrint(body, """
        <body>
            1
        </body>
        """)
    }

    func testForkedProviders() throws {
        struct Content: Component {
            func render() -> Node {
                Fragment {
                    Section()
                    A.Provider(value: A(1)) {
                        Section()
                    }
                    A.Provider(value: A(2)) {
                        Section()
                    }
                }
            }
        }

        struct Section: Component {
            @Context var a: A
            func render() -> Node {
                div {
                    a.value
                }
            }
        }

        let body = try document.createElement("body")
        let root = ReactRoot(element: body)
        let content = Content()
        root.render(node: content)

        XCTAssertPrint(body, """
        <body>
            <div>
                0
            </div>
            <div>
                1
            </div>
            <div>
                2
            </div>
        </body>
        """)
    }

    func testOverride() throws {
        struct Content: Component {
            func render() -> Node {
                A.Provider(value: A(1)) {
                    Chapter()
                }
            }
        }

        struct Chapter: Component {
            @Context var a: A
            func render() -> Node {
                div {
                    a.value
                    A.Provider(value: A(2)) {
                        Section()
                    }
                }
            }
        }

        struct Section: Component {
            @Context var a: A
            func render() -> Node {
                div {
                    a.value
                }
            }
        }

        let body = try document.createElement("body")
        let root = ReactRoot(element: body)
        let content = Content()
        root.render(node: content)

        XCTAssertPrint(body, """
        <body>
            <div>
                1
                <div>
                    2
                </div>
            </div>
        </body>
        """)
    }

    func testTwoValue() throws {
        struct Content: Component {
            func render() -> Node {
                Fragment {
                    A.Provider(value: A(1)) {
                        Section()
                    }
                    B.Provider(value: B(1)) {
                        Section()
                    }
                }
            }
        }

        struct Section: Component {
            @Context var a: A
            @Context var b: B
            func render() -> Node {
                div {
                    p {
                        a.value
                    }
                    p {
                        b.value
                    }
                }
            }
        }

        let body = try document.createElement("body")
        let root = ReactRoot(element: body)
        let content = Content()
        root.render(node: content)

        XCTAssertPrint(body, """
        <body>
            <div>
                <p>
                    1
                </p>
                <p>
                    0
                </p>
            </div>
            <div>
                <p>
                    0
                </p>
                <p>
                    1
                </p>
            </div>
        </body>
        """)
    }

    func testChangeSubscription() throws {
        struct Content: Component {
            var value: Int
            func render() -> Node {
                A.Provider(value: A(value)) {
                    Chapter()
                }
            }
        }

        struct Chapter: Component {
            var deps: Deps? { [] }

            func render() -> Node {
                div {
                    Section()
                }
            }
        }

        struct Section: Component {
            @Context var a: A
            func render() -> Node {
                p {
                    a.value
                }
            }
        }

        let body = try document.createElement("body")
        let root = ReactRoot(element: body)

        var evs: [String] = []
        root.willComponentRender = { (c) in
            switch c {
            case is Content:
                evs.append("c")
            case is Chapter:
                evs.append("h")
            case is Section:
                evs.append("s")
            default: break
            }
        }

        root.render(node: Content(value: 1))
        XCTAssertPrint(body, """
        <body>
            <div>
                <p>
                    1
                </p>
            </div>
        </body>
        """)
        XCTAssertEqual(evs, ["c", "h", "s"])
        evs = []

        root.render(node: Content(value: 1))
        XCTAssertPrint(body, """
        <body>
            <div>
                <p>
                    1
                </p>
            </div>
        </body>
        """)
        XCTAssertEqual(evs, ["c"])
        evs = []

        root.render(node: Content(value: 2))
        XCTAssertPrint(body, """
        <body>
            <div>
                <p>
                    2
                </p>
            </div>
        </body>
        """)
        XCTAssertEqual(evs, ["c", "s"])
        evs = []
    }

    func testPartialUpdate() throws {
        struct Content: Component {
            func render() -> Node {
                A.Provider(value: A(1)) {
                    Section()
                }
            }
        }

        struct Section: Component {
            @Context var a: A
            @State var x: Int = 10
            func render() -> Node {
                Fragment {
                    p {
                        a.value
                    }
                    p {
                        x
                    }
                }
            }
        }

        let body = try document.createElement("body")
        let root = ReactRoot(element: body)
        var section: Section!
        var evs: [String] = []
        root.willComponentRender = { (c) in
            switch c {
            case is Content:
                evs.append("c")
            case let c as Section:
                section = c
                evs.append("s")
            default: break
            }
        }

        root.render(node: Content())
        XCTAssertPrint(body, """
        <body>
            <p>
                1
            </p>
            <p>
                10
            </p>
        </body>
        """)
        XCTAssertEqual(evs, ["c", "s"])
        evs = []

        section.x = 11
        XCTAssertPrint(body, """
        <body>
            <p>
                1
            </p>
            <p>
                11
            </p>
        </body>
        """)
        XCTAssertEqual(evs, ["s"])
        evs = []
    }

    func testPartialUpdateBorder() throws {
        struct Content: Component {
            func render() -> Node {
                A.Provider(value: A(1)) {
                    div {
                        Chapter()
                    }
                }
            }
        }

        struct Chapter: Component {
            func render() -> Node {
                A.Provider(value: A(2)) {
                    div {
                        A.Provider(value: A(3)) {
                            Section()
                        }
                    }
                }
            }
        }

        struct Section: Component {
            @Context var a: A
            @State var x: Int = 0
            func render() -> Node {
                A.Provider(value: A(4)) {
                    div {
                        p {
                            a.value
                        }
                        div {
                            A.Provider(value: A(5)) {
                                a.value
                            }
                        }
                    }
                }
            }
        }

        let body = try document.createElement("body")
        let root = ReactRoot(element: body)
        var section: Section!
        var evs: [String] = []
        root.willComponentRender = { (c) in
            switch c {
            case is Content:
                evs.append("c")
            case is Chapter:
                evs.append("h")
            case let c as Section:
                section = c
                evs.append("s")
            default: break
            }
        }
        root.render(node: Content())
        XCTAssertPrint(body, """
        <body>
            <div>
                <div>
                    <div>
                        <p>
                            3
                        </p>
                        <div>
                            3
                        </div>
                    </div>
                </div>
            </div>
        </body>
        """)
        XCTAssertEqual(evs, ["c", "h", "s"])
        evs = []

        section.x = 2
        XCTAssertPrint(body, """
        <body>
            <div>
                <div>
                    <div>
                        <p>
                            3
                        </p>
                        <div>
                            3
                        </div>
                    </div>
                </div>
            </div>
        </body>
        """)
        XCTAssertEqual(evs, ["s"])
    }

    func testMultiplePartialUpdate() throws {
        struct Content: Component {
            var value: Int
            func render() -> Node {
                A.Provider(value: A(value)) {
                    div {
                        Chapter()
                    }
                }
            }
        }

        struct Chapter: Component {
            var deps: Deps? { [] }
            func render() -> Node {
                div {
                    Section()
                }
            }
        }

        struct Section: Component {
            @Context var a: A
            func render() -> Node {
                div {
                    p {
                        a.value
                    }
                    Paragraph()
                }
            }
        }

        struct Paragraph: Component {
            var deps: Deps? { [] }
            func render() -> Node {
                div {
                    Line()
                }
            }
        }

        struct Line: Component {
            @Context var a: A
            func render() -> Node {
                div {
                    a.value
                }
            }
        }

        let body = try document.createElement("body")
        let root = ReactRoot(element: body)
        var evs: [String] = []
        root.willComponentRender = { (c) in
            switch c {
            case is Content:
                evs.append("c")
            case is Chapter:
                evs.append("h")
            case is Section:
                evs.append("s")
            case is Paragraph:
                evs.append("p")
            case is Line:
                evs.append("l")
            default: break
            }
        }
        root.render(node: Content(value: 1))
        XCTAssertPrint(body, """
        <body>
            <div>
                <div>
                    <div>
                        <p>
                            1
                        </p>
                        <div>
                            <div>
                                1
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </body>
        """)
        XCTAssertEqual(evs, ["c", "h", "s", "p", "l"])
        evs = []

        root.render(node: Content(value: 2))
        XCTAssertPrint(body, """
        <body>
            <div>
                <div>
                    <div>
                        <p>
                            2
                        </p>
                        <div>
                            <div>
                                2
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </body>
        """)
        XCTAssertEqual(evs, ["c", "s", "l"])
        evs = []
    }

}
