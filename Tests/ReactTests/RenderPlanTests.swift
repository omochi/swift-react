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
            func render() -> Node {
                return Section()
            }
        }

        struct Section: Component {
            @State var count = 0
            func render() -> Node {
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
        root.willComponentRender = { (c) in
            switch c {
            case is Content:
                contentRenderCount += 1
            case is Section:
                sectionRenderCount += 1
            default: break
            }
        }

        let content = Content()
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

            func render() -> Node {
                let result = div {
                    "\(count)"
                }
                if count < 2 {
                    count += 1
                }
                return result
            }
        }

        var evs: [String] = []

        let body = try document.createElement("body")
        let root = ReactRoot(element: body)
        root.willComponentRender = { (c) in
            switch c {
            case is Content:
                evs.append("e")
            default: break
            }
        }
        root.didComponentRender = { (c) in
            switch c {
            case is Content:
                evs.append("x")
            default: break
            }
        }

        let content = Content()
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
            func render() -> Node {
                return Section()
            }
        }

        struct Section: Component {
            @State var count = 0
            func render() -> Node {
                return div()
            }
        }

        var evs: [String] = []

        let body = try document.createElement("body")
        let root = ReactRoot(element: body)
        root.willComponentRender = { (c) in
            switch c {
            case is Content:
                evs.append("c")
            case is Section:
                evs.append("s")
            default: break
            }
        }

        let content = Content()
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

            func render() -> Node {
                let section: Int = switch count {
                case 0: 0
                case 1: 0
                case 2: 1
                case 3: 1
                default: 2
                }

                return Section(value: section)
            }
        }

        struct Section: Component {
            var value: Int

            var deps: AnyHashable? { value }

            func render() -> Node {
                return "\(value)"
            }
        }

        var evs: [String] = []

        let body = try document.createElement("body")
        let root = ReactRoot(element: body)
        root.willComponentRender = { (c) in
            switch c {
            case let s as Section:
                evs.append("s\(s.value)")
            default: break
            }
        }

        let content = Content()
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
        root.willComponentRender = { (c) in
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
