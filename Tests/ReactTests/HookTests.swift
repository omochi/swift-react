import XCTest
import SRTJavaScriptKitEx
import SRTTestSupport
import SRTDOM
import React

final class HookTests: XCTestCase {
    override func setUp() {
        WebWindow.initializeJavaScriptKit()
        document = JSWindow.global.document
    }

    var document: JSDocument!

    func testRef() throws {
        struct Content: Component {
            @Ref var buttonRef: JSHTMLElement?

            func render() -> Node {
                return div {
                    button(ref: $buttonRef) { "hi" }
                }
            }
        }

        var refs: [JSHTMLElement?] = []

        let body = try document.createElement("body")
        let root = ReactRoot(element: body)
        root.willComponentRender = { (c) in
            switch c {
            case let c as Content:
                refs.append(c.buttonRef)
            default: break
            }
        }
        let content = Content()
        root.render(node: content)

        XCTAssertEqual(refs.count, 1)
        XCTAssertEqual(refs[safe: 0], .some(nil))

        root.render(node: content)

        let btn: JSHTMLElement = try XCTUnwrap(
            root.root?
                .find { $0.tagElement?.tagName == "button" }?
                .dom?.asHTMLElement()
        )

        XCTAssertEqual(refs.count, 2)
        XCTAssertEqual(refs[safe: 1], btn)
    }

    func testRefForward() throws {
        struct Button: Component {
            var buttonRefObject: RefObject<JSHTMLElement>
            func render() -> Node {
                return button(ref: buttonRefObject) { "push me" }
            }
        }

        struct Content: Component {
            @Ref var buttonRef: JSHTMLElement?

            func render() -> Node {
                return Button(buttonRefObject: $buttonRef)
            }
        }

        var refs: [JSHTMLElement?] = []

        let body = try document.createElement("body")
        let root = ReactRoot(element: body)
        root.willComponentRender = { (c) in
            switch c {
            case let c as Content:
                refs.append(c.buttonRef)
            default: break
            }
        }
        let content = Content()
        root.render(node: content)

        XCTAssertEqual(refs.count, 1)
        XCTAssertEqual(refs[safe: 0], .some(nil))

        root.render(node: content)

        let btn: JSHTMLElement = try XCTUnwrap(
            root.root?
                .find { $0.tagElement?.tagName == "button" }?
                .dom?.asHTMLElement()
        )

        XCTAssertEqual(refs.count, 2)
        XCTAssertEqual(refs[safe: 1], btn)
    }

    func testState() throws {
        struct Content: Component {
            @State var count = 0

            func render() -> Node {
                return div {
                    "\(count)"
                    button(
                        listeners: [
                            "click": Function { (ev) in
                                count += 1
                            }
                        ]
                    )
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
                <button />
            </div>
        </body>
        """)

        let btn: JSHTMLElement = try XCTUnwrap(
            root.root?
                .find { $0.tagElement?.tagName == "button" }?
                .dom?.asHTMLElement()
        )
        try btn.click()

        XCTAssertPrint(body, """
        <body>
            <div>
                1
                <button />
            </div>
        </body>
        """)
    }

    func testStateMultiple() throws {
        struct Content: Component {
            @State var count = 0

            func render() -> Node {
                return div()
            }
        }

        let body = try document.createElement("body")
        let root = ReactRoot(element: body)
        var renderCount = 0
        root.willComponentRender = { (c) in
            switch c {
            case is Content:
                renderCount += 1
            default: break
            }
        }

        let content = Content()
        root.render(node: content)
        XCTAssertEqual(renderCount, 1)
        XCTAssertPrint(body, """
        <body>
            <div />
        </body>
        """)
        content.count += 1
        XCTAssertEqual(renderCount, 2)
        content.count += 1
        XCTAssertEqual(renderCount, 3)
        content.count += 1
        XCTAssertEqual(renderCount, 4)
        XCTAssertPrint(body, """
        <body>
            <div />
        </body>
        """)
    }

}
