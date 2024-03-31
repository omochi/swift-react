import XCTest
import SRTTestSupport
import WebMock

final class WebNodePrintTests: XCTestCase {
    func testPrints() {
        XCTAssertPrint(
            WebHTMLElement("html"),
            "<html />"
        )

        do {
            let html = WebHTMLElement("html")
            let body = WebHTMLElement("body")
            html.appendChild(body)

            XCTAssertPrint(html,
            """
            <html>
                <body />
            </html>
            """
            )
        }

        do {
            let p = WebHTMLElement("p")
            let t = WebText("hello")
            p.appendChild(t)

            XCTAssertPrint(p,
            """
            <p>
                hello
            </p>
            """
            )
        }

//
//        XCTAssertPrint(
//            DOMTagNode(tagName: "div", strings: ["class": "box"]),
//            """
//            <div class="box" />
//            """
//        )
//
//        XCTAssertPrint(
//            DOMTagNode(tagName: "div", strings: ["class": "box"], children: [
//                DOMTagNode(tagName: "p")
//            ]),
//            """
//            <div class="box">
//                <p />
//            </div>
//            """
//        )
//

    }
}
