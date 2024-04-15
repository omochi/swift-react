import XCTest
import SRTTestSupport
import SRTDOM
import React

final class KeyMatchTests: XCTestCase {
    override func setUp() {
        WebWindow.initializeJavaScriptKit()
        document = JSWindow.global.document
    }

    var document: JSDocument!

    func testTwinKeySwap() throws {
        struct Section: Component {
            var key: AnyHashable?

            var id: Int

            var deps: Deps? { [key, id] }

            func render() -> Node {
                return div {
                    "\(id)"
                }
            }
        }

        struct Content: Component {
            var ids: [Int]

            func render() -> Node {
                ids.map { (id) in
                    Section(key: id, id: id)
                }
            }
        }

        let body = try document.createElement("body")
        let root = ReactRoot(element: body)
        root.render(node: Content(ids: [1, 2]))
        XCTAssertPrint(root.dom, """
        <body>
            <div>
                1
            </div>
            <div>
                2
            </div>
        </body>
        """)
        root.render(node: Content(ids: [2, 1]))
        XCTAssertPrint(root.dom, """
        <body>
            <div>
                2
            </div>
            <div>
                1
            </div>
        </body>
        """)
    }

    func testMultiKeyMatchRender() throws {
        struct Section: Component {
            var key: AnyHashable?

            var id: Int

            var deps: Deps? { [key, id] }

            func render() -> Node {
                return div {
                    "\(id)"
                }
            }
        }

        struct Content: Component {
            var ids: [Int]

            func render() -> Node {
                div {
                    ids.map { (id) in
                        Section(key: id, id: id)
                    }
                }
            }
        }

        var evs: [Int] = []

        let body = try document.createElement("body")
        let root = ReactRoot(element: body)
        root.willComponentRender = { (c) in
            switch c {
            case let c as Section:
                evs.append(c.id)
            default: break
            }
        }
        root.render(node: Content(ids: [1, 2, 3]))
        XCTAssertPrint(root.dom, """
        <body>
            <div>
                <div>
                    1
                </div>
                <div>
                    2
                </div>
                <div>
                    3
                </div>
            </div>
        </body>
        """)
        XCTAssertEqual(evs, [1, 2, 3])
        evs = []

        root.render(node: Content(ids: [2, 3, 4]))
        XCTAssertEqual(evs, [4])
        XCTAssertPrint(root.dom, """
        <body>
            <div>
                <div>
                    2
                </div>
                <div>
                    3
                </div>
                <div>
                    4
                </div>
            </div>
        </body>
        """)
        evs = []

        root.render(node: Content(ids: [5, 4, 3, 2]))
        XCTAssertEqual(evs, [5])
        XCTAssertPrint(root.dom, """
        <body>
            <div>
                <div>
                    5
                </div>
                <div>
                    4
                </div>
                <div>
                    3
                </div>
                <div>
                    2
                </div>
            </div>
        </body>
        """)
        evs = []
    }

    func testMultiKeyMatchEffect() throws {
        struct Prove: ContextValue {
            static var defaultValue: Prove = .undefinedDefault()
            
            var onRender: Function<Void, String>
        }

        struct Section: Component {
            var key: AnyHashable?

            var id: Int

            var deps: Deps? { [key, id] }

            @Context var prove: Prove
            @Effect var effect

            func render() -> Node {
                $effect {
                    prove.onRender("s\(id)")
                    return nil
                }

                return div {
                    "\(id)"
                }
            }
        }

        struct Content: Component {
            var prove: Prove

            var ids: [Int]

            func render() -> Node {
                Prove.Provider(value: prove) {
                    ids.map { (id) in
                        Section(key: id, id: id)
                    }
                }
            }
        }

        let body = try document.createElement("body")
        let root = ReactRoot(element: body)
        var evs: [String] = []
        let prove = Prove(
            onRender: Function {
                evs.append($0)
            }
        )
        root.render(
            node: Content(
                prove: prove,
                ids: [1, 2, 3]
            )
        )
        XCTAssertEqual(evs, ["s1", "s2", "s3"])
        evs = []

        root.render(
            node: Content(
                prove: prove,
                ids: [1, 2, 3, 4]
            )
        )
        XCTAssertEqual(evs, ["s4"])
        evs = []

        root.render(
            node: Content(
                prove: prove,
                ids: [5, 4, 3]
            )
        )
        XCTAssertEqual(evs, ["s5"])
        evs = []
    }
}

