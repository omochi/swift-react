import XCTest
import SRTTestSupport
import DOMModule

final class DOMPrintTests: XCTestCase {
    func testPrints() {
        XCTAssertPrint(
            DOMTagNode(tagName: "html"),
            "<html />"
        )

        XCTAssertPrint(
            DOMTagNode(tagName: "html", children: [
                DOMTagNode(tagName: "body", children: [])
            ]),
            """
            <html>
                <body />
            </html>
            """
        )

        XCTAssertPrint(
            DOMTagNode(tagName: "div", strings: ["class": "box"]),
            """
            <div class="box" />
            """
        )

        XCTAssertPrint(
            DOMTagNode(tagName: "div", strings: ["class": "box"], children: [
                DOMTagNode(tagName: "p")
            ]),
            """
            <div class="box">
                <p />
            </div>
            """
        )

        XCTAssertPrint(
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
}
