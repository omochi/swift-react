import XCTest
import SRTTestSupport
import SRTDOM
import React

final class EffectHookTests: XCTestCase {
    override func setUp() {
        WebWindow.initializeJavaScriptKit()
        document = JSWindow.global.document
    }

    var document: JSDocument!

    func testNoDeps() throws {
        struct Content: Component {
            var setup: () -> Void
            var cleanup: () -> Void
            @Effect var effect
            func render() -> Node {
                $effect {
                    setup()
                    return {
                        cleanup()
                    }
                }

                return div()
            }
        }

        var evs: [String] = []

        let body = try document.createElement("body")
        let root = ReactRoot(element: body)
        root.render(
            node: Content(
                setup: { evs.append("s1") },
                cleanup: { evs.append("c1") }
            )
        )
        XCTAssertPrint(body, """
        <body>
            <div />
        </body>
        """)
        XCTAssertEqual(evs, ["s1"])
        evs = []

        root.render(
            node: Content(
                setup: { evs.append("s2") },
                cleanup: { evs.append("c2") }
            )
        )
        XCTAssertEqual(evs, ["c1", "s2"])
        evs = []

        root.render(node: nil)
        XCTAssertEqual(evs, ["c2"])
        evs = []
    }

    func testNoCleanup() throws {
        struct Content: Component {
            var setup: () -> Void
            @Effect var effect
            func render() -> Node {
                $effect {
                    setup()
                    return nil
                }

                return div()
            }
        }

        var evs: [String] = []

        let body = try document.createElement("body")
        let root = ReactRoot(element: body)
        root.render(
            node: Content(
                setup: { evs.append("s1") }
            )
        )
        XCTAssertEqual(evs, ["s1"])
        evs = []

        root.render(
            node: Content(
                setup: { evs.append("s2") }
            )
        )
        XCTAssertEqual(evs, ["s2"])
        evs = []

        root.render(node: nil)
        XCTAssertEqual(evs, [])
        evs = []
    }

    func testEmptyDeps() throws {
        struct Content: Component {
            var setup: () -> Void
            var cleanup: () -> Void
            @Effect var effect
            func render() -> Node {
                $effect(deps: []) {
                    setup()
                    return {
                        cleanup()
                    }
                }

                return div()
            }
        }

        var evs: [String] = []

        let body = try document.createElement("body")
        let root = ReactRoot(element: body)
        root.render(
            node: Content(
                setup: { evs.append("s1") },
                cleanup: { evs.append("c1") }
            )
        )
        XCTAssertEqual(evs, ["s1"])
        evs = []

        root.render(
            node: Content(
                setup: { evs.append("s2") },
                cleanup: { evs.append("c2") }
            )
        )
        XCTAssertEqual(evs, [])
        evs = []

        root.render(node: nil)
        XCTAssertEqual(evs, ["c1"])
        evs = []
    }

    func testDeps() throws {
        struct Content: Component {
            var value: Int
            var setup: () -> Void
            var cleanup: () -> Void
            @Effect var effect
            func render() -> Node {
                $effect(deps: [value]) {
                    setup()
                    return {
                        cleanup()
                    }
                }

                return div()
            }
        }

        var evs: [String] = []

        let body = try document.createElement("body")
        let root = ReactRoot(element: body)
        root.render(
            node: Content(
                value: 1,
                setup: { evs.append("s1") },
                cleanup: { evs.append("c1") }
            )
        )
        XCTAssertEqual(evs, ["s1"])
        evs = []

        root.render(
            node: Content(
                value: 1,
                setup: { evs.append("s2") },
                cleanup: { evs.append("c2") }
            )
        )
        XCTAssertEqual(evs, [])
        evs = []

        root.render(
            node: Content(
                value: 2,
                setup: { evs.append("s3") },
                cleanup: { evs.append("c3") }
            )
        )
        XCTAssertEqual(evs, ["c1", "s3"])
        evs = []

        root.render(
            node: Content(
                value: 2,
                setup: { evs.append("s4") },
                cleanup: { evs.append("c4") }
            )
        )
        XCTAssertEqual(evs, [])
        evs = []

        root.render(node: nil)
        XCTAssertEqual(evs, ["c3"])
        evs = []
    }

    func testRunAfterRender() throws {
        struct Content: Component {
            var setup: () -> Void
            func render() -> Node {
                Fragment {
                    Head(setup: setup)
                    Tail()
                }
            }
        }

        struct Head: Component {
            @Effect var effect
            var setup: () -> Void
            func render() -> Node {
                $effect {
                    setup()
                    return nil
                }

                return 1
            }
        }

        struct Tail: Component {
            func render() -> Node {
                2
            }
        }

        var evs: [String] = []
        let body = try document.createElement("body")
        let root = ReactRoot(element: body)
        root.willComponentRender = { (c) in
            switch c {
            case is Content:
                evs.append("c")
            case is Head:
                evs.append("h")
            case is Tail:
                evs.append("t")
            default: break
            }
        }
        root.render(
            node: Content(
                setup: { evs.append("e") }
            )
        )
        evs = ["c", "h", "t", "e"]
    }
}
