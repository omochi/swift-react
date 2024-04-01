import XCTest
import SRTTestSupport
import JavaScriptKitShim
import WebMock
import SRTDOM

final class DOMPrintTests: XCTestCase {
    override func setUp() {
        JSObject.global = JSObject(native: WebWindow())

        document = JSWindow.global.document
    }

    var document: JSDocument!

    func testPrints() {
        do {
            let html = document.createElement("html")
            XCTAssertPrint(html,
            "<html />"
            )
        }

        do {
            let html = document.createElement("html")
            let body = document.createElement("body")
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
            let div = document.createElement("div")
            div.setAttribute("class", "box")

            XCTAssertPrint(div,
            """
            <div class="box" />
            """
            )
        }
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
//        XCTAssertPrint(
//            DOMTagNode(tagName: "p", children: [
//                DOMTextNode(text: "hello")
//            ]),
//            """
//            <p>
//                hello
//            </p>
//            """
//        )
    }
}
