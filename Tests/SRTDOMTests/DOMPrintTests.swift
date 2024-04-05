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

    func testPrints() throws {
        do {
            let html = try document.createElement("html")
            XCTAssertPrint(html,
            "<html />"
            )
        }

        do {
            let html = try document.createElement("html")
            let body = try document.createElement("body")
            try html.asNode().appendChild(body.asNode())

            XCTAssertPrint(html,
            """
            <html>
                <body />
            </html>
            """
            )
        }

        do {
            let div = try document.createElement("div")
            try div.setAttribute("class", "box")

            XCTAssertPrint(div,
            """
            <div class="box" />
            """
            )
        }

        do {
            let div = try document.createElement("div")
            try div.setAttribute("class", "box")
            let p = try document.createElement("p")
            try div.asNode().appendChild(p.asNode())

            XCTAssertPrint(div,
            """
            <div class="box">
                <p />
            </div>
            """
            )
        }

        do {
            let p = try document.createElement("p")
            let t = try document.createTextNode("hello")
            try p.asNode().appendChild(t.asNode())

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
