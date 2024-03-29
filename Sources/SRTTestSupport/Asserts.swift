import XCTest
import DOMModule

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

public func XCTAssertPrint(
    _ node: DOMNode, _ expected: String,
    file: StaticString = #file, line: UInt = #line
) {
    let actual = node.description
    XCTAssertEqual(actual, expected, file: file, line: line)
}
