import XCTest
import DOMModule
import React

final class RenderTests: XCTestCase {
    func testRender() {
        let dom = DOMTagNode(tagName: "body")
        assertPrint(dom, """
        <body />
        """)

        let root = ReactRoot(element: dom)
        root.render(
            node: TagElement(tagName: "div")
        )
        assertPrint(dom, """
        <body>
            <div />
        </body>
        """)
    }

    func assertPrint(
        _ node: DOMNode, _ expected: String,
        file: StaticString = #file, line: UInt = #line
    ) {
        let actual = node.description

        XCTAssertEqual(actual, expected, file: file, line: line)
    }
}
