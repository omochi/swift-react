import XCTest
import SRTTestSupport
import SRTJavaScriptKitEx

final class JavaScriptKitTests: XCTestCase {
    func testClosureAsFunction() throws {
        let fn = JSClosure { (_) in
            return 7.jsValue
        }
        let obj = try JSObject.mustConstruct(from: fn.jsValue)
        XCTAssertTrue(obj is JSFunction)

        let ret = try Int.mustConstruct(from: fn())
        XCTAssertEqual(ret, 7)
    }
}
