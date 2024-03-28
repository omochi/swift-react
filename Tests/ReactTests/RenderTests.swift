import XCTest
import DOMModule
import React

final class RenderTests: XCTestCase {

    struct AView: ReactComponent {
        func render() -> (any ReactNode)? {
            TagElement(tagName: "div")
        }
    }

    func testRender() {
        do {
            let dom = DOMTagNode(tagName: "body")
            assertPrint(dom, """
            <body />
            """)

            let root = ReactRoot(element: dom)
            root.render(node: TagElement(tagName: "div"))
            assertPrint(dom, """
            <body>
                <div />
            </body>
            """)

            root.render(node: nil)
            assertPrint(dom, """
            <body />
            """)

            root.render(node: AView())
            assertPrint(dom, """
            <body>
                <div />
            </body>
            """)
        }

        do {
            let dom = DOMTagNode(tagName: "body")
            let root = ReactRoot(element: dom)
            root.render(node: TagElement(tagName: "div"))
            assertPrint(dom, """
            <body>
                <div />
            </body>
            """)

            root.render(node: TagElement(tagName: "div", attributes: ["class": "box"]))
            assertPrint(dom, """
            <body>
                <div class="box" />
            </body>
            """)

        }
    }

    func assertPrint(
        _ node: DOMNode, _ expected: String,
        file: StaticString = #file, line: UInt = #line
    ) {
        let actual = node.description

        XCTAssertEqual(actual, expected, file: file, line: line)
    }
}
