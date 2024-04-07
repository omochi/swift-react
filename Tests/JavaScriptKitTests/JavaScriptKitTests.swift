import XCTest
import SRTTestSupport
import SRTJavaScriptKitEx

final class JavaScriptKitTests: XCTestCase {
    func testClosureAsFunction() throws {
        let clo = JSClosure { (_) in
            return 7.jsValue
        }
        let obj = try JSObject.mustConstruct(from: clo.jsValue)
        XCTAssertFalse(obj is JSFunction)

        let fn = clo.asFunction()
        let ret = try Int.mustConstruct(from: try fn())
        XCTAssertEqual(ret, 7)
    }
}
