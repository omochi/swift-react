import XCTest
import DOMModule

final class DOMPrintTests: XCTestCase {
    func testPrints() {
        assertPrint(
            DOMTagNode(tagName: "html"),
            "<html />"
        )

        assertPrint(
            DOMTagNode(tagName: "html", children: [
                DOMTagNode(tagName: "body", children: [])
            ]),
            """
            <html>
                <body />
            </html>
            """
        )

        assertPrint(
            DOMTagNode(tagName: "div", attributes: ["class": "box"]),
            """
            <div class="box" />
            """
        )

        assertPrint(
            DOMTagNode(tagName: "div", attributes: ["class": "box"], children: [
                DOMTagNode(tagName: "p")
            ]),
            """
            <div class="box">
                <p />
            </div>
            """
        )

        assertPrint(
            DOMTagNode(tagName: "p", children: [
                DOMTextNode(text: "hello")
            ]),
            """
            <p>
                hello
            </p>
            """
        )
    }

    func assertPrint(
        _ node: DOMNode, _ expected: String,
        file: StaticString = #file, line: UInt = #line
    ) {
        let actual = node.description

        XCTAssertEqual(actual, expected, file: file, line: line)
    }

}
