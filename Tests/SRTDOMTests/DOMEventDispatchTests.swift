import XCTest
import SRTCore
import SRTJavaScriptKitEx
import SRTTestSupport
import SRTDOM

final class DOMEventDispatchTests: XCTestCase {
    override func setUp() {
        WebWindow.initializeJavaScriptKit()
        document = JSWindow.global.document
    }

    var document: JSDocument!

    func testEventDispatch() throws {
        let div = try document.createElement("div")

        var ls0Events: [JSEvent] = []
        let ls0 = DOMEventListener { (ev) in
            ls0Events.append(ev)
        }

        var ls1Events: [JSEvent] = []
        let ls1 = DOMEventListener { (ev) in
            ls1Events.append(ev)
        }

        try div.addEventListener("click", ls0)
        try div.addEventListener("click", ls1)

        let MouseEvent = JSWindow.global.MouseEvent

        let ev0 = try MouseEvent.new("click")
        try div.dispatchEvent(ev0)

        XCTAssertEqual(ls0Events.count, 1)
        XCTAssertEqual(ls0Events[safe: 0], ev0.asEvent())
        XCTAssertEqual(ls1Events.count, 1)
        XCTAssertEqual(ls1Events[safe: 0], ev0.asEvent())

        try div.removeEventListener("click", ls1)

        let ev1 = try MouseEvent.new("click")
        try div.dispatchEvent(ev1)

        XCTAssertEqual(ls0Events.count, 2)
        XCTAssertEqual(ls0Events[safe: 1], ev1.asEvent())
        XCTAssertEqual(ls1Events.count, 1)
    }

}
