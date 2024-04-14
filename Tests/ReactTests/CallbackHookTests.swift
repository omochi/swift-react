import XCTest
import SRTTestSupport
import SRTDOM
import React

final class CallbackHookTests: XCTestCase {
    override func setUp() {
        WebWindow.initializeJavaScriptKit()
        document = JSWindow.global.document
    }

    var document: JSDocument!

    func testCallback() throws {
        struct Form: Component {
            var onSubmit: Function<Void>

            var deps: Deps? {
                [onSubmit]
            }

            func render() -> Node {
                button()
            }
        }

        struct Content: Component {
            var count = 0

            @Callback var onSubmit: Function<Void>

            func render() -> Node {
                $onSubmit(deps: []) { () in

                }

                return Form(onSubmit: onSubmit)
            }
        }

        let body = try document.createElement("body")
        let root = ReactRoot(element: body)
        var renderCount = 0
        root.willComponentRender = { (c) in
            switch c {
            case is Form:
                renderCount += 1
            default: break
            }
        }

        root.render(node: Content())
        XCTAssertEqual(renderCount, 1)

        root.render(node: Content())
        XCTAssertEqual(renderCount, 1)
    }

}
