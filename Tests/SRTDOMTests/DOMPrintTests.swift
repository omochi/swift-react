import XCTest
import SRTTestSupport
import JavaScriptKitShim
import SRTDOM
#if USES_JAVASCRIPT_KIT_MOCK
import WebMock
#endif

final class DOMPrintTests: XCTestCase {
    override func setUp() {
#if USES_JAVASCRIPT_KIT_MOCK
        WebWindow.initializeJavaScriptKit()
#endif

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
            html.asNode().appendChild(body.asNode())

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

        do {
            let div = document.createElement("div")
            div.setAttribute("class", "box")
            let p = document.createElement("p")
            div.asNode().appendChild(p.asNode())

            XCTAssertPrint(div,
            """
            <div class="box">
                <p />
            </div>
            """
            )
        }

        do {
            let p = document.createElement("p")
            let t = document.createTextNode("hello")
            p.asNode().appendChild(t.asNode())

            XCTAssertPrint(p,
            """
            <p>
                hello
            </p>
            """
            )
        }
    }
}
