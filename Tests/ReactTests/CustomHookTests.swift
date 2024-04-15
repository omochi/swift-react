import XCTest
import SRTTestSupport
import SRTDOM
import React

final class CustomHookTests: XCTestCase {
    override func setUp() {
        WebWindow.initializeJavaScriptKit()
        document = JSWindow.global.document
    }

    var document: JSDocument!

    func testCustom() throws {
        @propertyWrapper
        struct ChangeCounter: Hook {
            init(wrappedValue: Int) {
                _count = State(wrappedValue: wrappedValue)
            }

            @State var count: Int

            @Effect var mount

            var projectedValue: Self { self }

            var wrappedValue: Int { count }

            func callAsFunction(value: Int) {
                $mount(deps: [value]) {
                    count += 1
                    return nil
                }
            }
        }

        struct Content: Component {
            var value: Int
            @ChangeCounter var counter = 0

            func render() -> Node {
                $counter(value: value)

                return div {
                    counter
                }
            }
        }

        let body = try document.createElement("body")
        let root = ReactRoot(element: body)
        root.render(node: Content(value: 1))
        XCTAssertPrint(root.dom, """
        <body>
            <div>
                1
            </div>
        </body>
        """)

        root.render(node: Content(value: 1))
        XCTAssertPrint(root.dom, """
        <body>
            <div>
                1
            </div>
        </body>
        """)

        root.render(node: Content(value: 2))
        XCTAssertPrint(root.dom, """
        <body>
            <div>
                2
            </div>
        </body>
        """)
    }
}
