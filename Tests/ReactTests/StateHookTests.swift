import XCTest
import SRTTestSupport
import SRTDOM
import React

final class StateHookTests: XCTestCase {
    override func setUp() {
        WebWindow.initializeJavaScriptKit()
        document = JSWindow.global.document
    }

    var document: JSDocument!

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
                .find { $0.htmlElement?.tagName == "button" }?
                .instance?.dom?.asHTMLElement()
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

    func testStateChange() throws {
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
        content.count = 1
        XCTAssertEqual(renderCount, 2)
        content.count = 1
        XCTAssertEqual(renderCount, 2)
        content.count = 2
        XCTAssertEqual(renderCount, 3)
        content.count = 2
        XCTAssertEqual(renderCount, 3)
    }

}
