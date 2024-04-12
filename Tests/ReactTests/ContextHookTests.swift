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

}
