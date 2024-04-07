import XCTest

public func XCTAssertArrayIdentical(
    _ actual: [AnyObject?],
    _ expect: [AnyObject?],
    _ message: @autoclosure () -> String = "",
    file: StaticString = #filePath,
    line: UInt = #line
) {
    XCTAssertEqual(actual.count, expect.count, file: file, line: line)
    for (a, e) in zip(actual, expect) {
        XCTAssertIdentical(a, e, file: file, line: line)
    }
}

public func XCTAssertPrint(
    _ value: some CustomStringConvertible, _ expected: String,
    file: StaticString = #filePath, line: UInt = #line
) {
    let actual = value.description
    XCTAssertEqual(actual, expected, file: file, line: line)
}
