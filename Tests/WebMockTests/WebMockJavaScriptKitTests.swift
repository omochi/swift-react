import XCTest
import SRTTestSupport
import JavaScriptKitMock
import WebMock

final class WebMockJavaScriptKitTests: XCTestCase {
    func testBuildTree() {
        let window = JSObject(native: WebWindow())
        let document = window.document
        let div = document.createElement("div")
        div.setAttribute("class", "box")
        let h1 = document.createElement("h1")
        div.appendChild(h1)
        let title = document.createTextNode("hello world")
        h1.appendChild(title)
        let button = document.createElement("button")
        div.appendChild(button)
        let label = document.createTextNode("login")
        button.appendChild(label)
        XCTAssertEqual(div.description.string!,
        """
        <div class="box">
            <h1>
                hello world
            </h1>
            <button>
                login
            </button>
        </div>
        """
        )
    }
}
