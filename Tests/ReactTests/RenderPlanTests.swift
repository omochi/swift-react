import XCTest
import SRTJavaScriptKitEx
import SRTTestSupport
import SRTDOM
import React

final class RenderPlanTests: XCTestCase {
    override func setUp() {
        WebWindow.initializeJavaScriptKit()
        document = JSWindow.global.document
    }

    var document: JSDocument!

    func testPartialRender() throws {
        struct Content: Component {
            var onRender: (Self) -> Void
            var onSectionRender: (Section) -> Void

            func render() -> Node {
                onRender(self)
                return Section(
                    onRender: onSectionRender
                )
            }
        }

        struct Section: Component {
            @State var count = 0
            var onRender: (Self) -> Void
            func render() -> Node {
                onRender(self)
                return div {
                    "\(count)"
                    button(
                        listeners: [
                            "click": Function { (_) in
                                count += 1
                            }
                        ]
                    )
                }
            }
        }

        var contentRenderCount = 0
        var sectionRenderCount = 0

        let body = try document.createElement("body")
        let root = ReactRoot(element: body)

        let content = Content(
            onRender: { (_) in contentRenderCount += 1 },
            onSectionRender: { (_) in sectionRenderCount += 1 }
        )

        root.render(node: content)

        XCTAssertEqual(contentRenderCount, 1)
        XCTAssertEqual(sectionRenderCount, 1)

        let btn: JSHTMLElement = try XCTUnwrap(
            root.root?
                .find { $0.tagElement?.tagName == "button" }?
                .dom?.asHTMLElement()
        )
        try btn.click()

        XCTAssertEqual(contentRenderCount, 1)
        XCTAssertEqual(sectionRenderCount, 2)
    }

    func testSerializedRender() throws {
        struct Content: Component {
            @State var count = 0

            var onRenderEnter: () -> Void
            var onRenderExit: () -> Void

            func render() -> Node {
                onRenderEnter()
                let result = div {
                    "\(count)"
                }
                if count < 2 {
                    count += 1
                }
                onRenderExit()
                return result
            }
        }

        let body = try document.createElement("body")
        let root = ReactRoot(element: body)

        var evs: [String] = []

        let content = Content(
            onRenderEnter: { evs.append("e") },
            onRenderExit: { evs.append("x") }
        )

        root.render(node: content)

        XCTAssertEqual(evs, ["e", "x", "e", "x", "e", "x"])

        XCTAssertPrint(body, """
        <body>
            <div>
                2
            </div>
        </body>
        """)
    }

    func testReorderingRender() throws {
        struct Content: Component {
            @State var count = 0
            var onContentRender: () -> Void
            var onSectionRender: () -> Void
            func render() -> Node {
                onContentRender()
                return Section(onRender: onSectionRender)
            }
        }

        struct Section: Component {
            @State var count = 0
            var onRender: () -> Void
            func render() -> Node {
                onRender()
                return div()
            }
        }

        let body = try document.createElement("body")
        let root = ReactRoot(element: body)

        var evs: [String] = []

        let content = Content(
            onContentRender: { evs.append("c") },
            onSectionRender: { evs.append("s") }
        )
        root.render(node: content)

        let section: Section = try XCTUnwrap(
            root.root?
                .find { $0.ghost.component is Section }?
                .ghost.component as? Section
        )
        XCTAssertEqual(evs, ["c", "s"])

        root.pause()

        section.count += 1
        content.count += 1
        XCTAssertEqual(evs, ["c", "s"])

        root.resume()
        XCTAssertEqual(evs, ["c", "s", "c", "s", "s"])
    }

    func testSkipChildren() throws {
        struct Content: Component {
            @State var count = 0

            var probe: (String) -> Void

            func render() -> Node {
                let section: Int = switch count {
                case 0: 0
                case 1: 0
                case 2: 1
                case 3: 1
                default: 2
                }

                return Section(probe: probe, value: section)
            }
        }

        struct Section: Component {
            var probe: (String) -> Void

            var value: Int

            var deps: AnyHashable? { value }

            func render() -> Node {
                probe("s\(value)")
                return "\(value)"
            }
        }


        let body = try document.createElement("body")
        let root = ReactRoot(element: body)

        var evs: [String] = []

        let content = Content(
            probe: { evs.append($0) }
        )
        root.render(node: content)

        XCTAssertEqual(evs, ["s0"])

        content.count += 1
        XCTAssertEqual(evs, ["s0"])

        content.count += 1
        XCTAssertEqual(evs, ["s0", "s1"])

        content.count += 1
        XCTAssertEqual(evs, ["s0", "s1"])

        content.count += 1
        XCTAssertEqual(evs, ["s0", "s1", "s2"])
    }

    func testSkipFragmentChildren() throws {
        struct Section: Component {
            var `class`: String
            var text: String

            var deps: AnyHashable? {
                AnyDeps(`class`, text)
            }

            func render() -> Node {
                return div(attributes: ["class": `class`]) {
                    text
                }
            }
        }

        var renderCount = 0

        let section = Section(
            class: "section",
            text: "hello"
        )

        let content = Fragment(children: [section])

        let body = try document.createElement("body")
        let root = ReactRoot(element: body)
        root.onComponentRender = { (c) in
            switch c {
            case is Fragment:
                renderCount += 1
            default: break
            }
        }
        root.render(node: content)
        XCTAssertEqual(renderCount, 1)

        root.render(node: content)
        XCTAssertEqual(renderCount, 1)
    }
}
