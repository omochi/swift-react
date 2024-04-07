import XCTest
import SRTJavaScriptKitEx
import SRTTestSupport
import SRTDOM

final class DOMPrintTests: XCTestCase {
    override func setUp() {
        WebWindow.initializeJavaScriptKit()
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
            try html.appendChild(body)

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
            try div.appendChild(p)

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
            try p.appendChild(t)

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
