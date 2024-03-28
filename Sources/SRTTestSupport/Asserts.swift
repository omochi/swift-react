import XCTest

public func XCTAssertArrayIdentical(
    _ actual: [AnyObject?],
    _ expect: [AnyObject?],
    _ message: @autoclosure () -> String = "",
    file: StaticString = #file,
    line: UInt = #line
) {
    XCTAssertEqual(actual.count, expect.count, file: file, line: line)
    for (a, e) in zip(actual, expect) {
        XCTAssertIdentical(a, e, file: file, line: line)
    }
}
