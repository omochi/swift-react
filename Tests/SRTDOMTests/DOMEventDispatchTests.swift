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

        var ls0Events: [JSObject] = []
        let ls0 = JSClosure { (args) in
            let ev: JSObject = .unsafeConstruct(from: args, at: 0)
            ls0Events.append(ev)
            return .undefined
        }

        var ls1Events: [JSObject] = []
        let ls1 = JSClosure { (args) in
            let ev: JSObject = .unsafeConstruct(from: args, at: 0)
            ls1Events.append(ev)
            return .undefined
        }

        try div.addEventListener("click", ls0)
        try div.addEventListener("click", ls1)

        let MouseEvent = JSWindow.global.MouseEvent

        let ev0 = try MouseEvent.new("click")
        try div.dispatchEvent(ev0)

        XCTAssertEqual(ls0Events.count, 1)
        XCTAssertEqual(ls0Events[safe: 0], ev0.jsObject)
        XCTAssertEqual(ls1Events.count, 1)
        XCTAssertEqual(ls1Events[safe: 0], ev0.jsObject)

        try div.removeEventListener("click", ls1)

        let ev1 = try MouseEvent.new("click")
        try div.dispatchEvent(ev1)

        XCTAssertEqual(ls0Events.count, 2)
        XCTAssertEqual(ls0Events[safe: 1], ev1.jsObject)
        XCTAssertEqual(ls1Events.count, 1)
    }

}
