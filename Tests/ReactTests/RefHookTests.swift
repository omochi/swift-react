import XCTest
import SRTTestSupport
import SRTDOM
import React

final class RefHookTests: XCTestCase {
    override func setUp() {
        WebWindow.initializeJavaScriptKit()
        document = JSWindow.global.document
    }

    var document: JSDocument!

    func testRef() throws {
        struct Content: Component {
            @Ref var buttonRef: JSHTMLElement?

            func render() -> Node {
                return div {
                    button(ref: $buttonRef) { "hi" }
                }
            }
        }

        var refs: [JSHTMLElement?] = []

        let body = try document.createElement("body")
        let root = ReactRoot(element: body)
        root.willComponentRender = { (c) in
            switch c {
            case let c as Content:
                refs.append(c.buttonRef)
            default: break
            }
        }
        let content = Content()
        root.render(node: content)

        XCTAssertEqual(refs.count, 1)
        XCTAssertEqual(refs[safe: 0], .some(nil))

        root.render(node: content)

        let btn: JSHTMLElement = try XCTUnwrap(
            root.root?
                .find { $0.tagElement?.tagName == "button" }?
                .dom?.asHTMLElement()
        )

        XCTAssertEqual(refs.count, 2)
        XCTAssertEqual(refs[safe: 1], btn)
    }

    func testRefForward() throws {
        struct Button: Component {
            var buttonRefObject: RefObject<JSHTMLElement>
            func render() -> Node {
                return button(ref: buttonRefObject) { "push me" }
            }
        }

        struct Content: Component {
            @Ref var buttonRef: JSHTMLElement?

            func render() -> Node {
                return Button(buttonRefObject: $buttonRef)
            }
        }

        var refs: [JSHTMLElement?] = []

        let body = try document.createElement("body")
        let root = ReactRoot(element: body)
        root.willComponentRender = { (c) in
            switch c {
            case let c as Content:
                refs.append(c.buttonRef)
            default: break
            }
        }
        let content = Content()
        root.render(node: content)

        XCTAssertEqual(refs.count, 1)
        XCTAssertEqual(refs[safe: 0], .some(nil))

        root.render(node: content)

        let btn: JSHTMLElement = try XCTUnwrap(
            root.root?
                .find { $0.tagElement?.tagName == "button" }?
                .dom?.asHTMLElement()
        )

        XCTAssertEqual(refs.count, 2)
        XCTAssertEqual(refs[safe: 1], btn)
    }
}
