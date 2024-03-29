import XCTest
import SRTTestSupport
import ReactInterface
import VDOMModule

final class VNodeTests: XCTestCase {

    struct AView: Component {
        func render() -> Node { nil }
    }

    func testParentTag() {
        do {
            let n0 = VNode.tag("div")
            XCTAssertNil(n0.parentTagNode)
        }

        do {
            let n0 = VNode.tag("div")
            let n1 = VNode.tag("p")
            n0.appendChild(n1)
            XCTAssertIdentical(n1.parentTagNode, n0)
        }

        do {
            let n0 = VNode.tag("div")
            let n1 = VNode(component: AView())
            n0.appendChild(n1)
            let n2 = VNode.tag("p")
            n1.appendChild(n2)
            XCTAssertIdentical(n2.parentTagNode, n0)
        }
    }

    func testPrevSiblingTag() throws {
        do {
            let n0 = VNode.tag("div")
            let n1_0 = VNode.tag("p")
            n0.appendChild(n1_0)
            let n1_1 = VNode.tag("p")
            n0.appendChild(n1_1)
            XCTAssertNil(try n0.prevSiblingTagNode)
            XCTAssertNil(try n1_0.prevSiblingTagNode)
            XCTAssertIdentical(try n1_1.prevSiblingTagNode, n1_0)
        }

        do {
            let n0 = VNode.tag("div")
            let n1_0 = VNode(component: AView())
            n0.appendChild(n1_0)
            let n2_0 = VNode.tag("p")
            n1_0.appendChild(n2_0)

            let n1_1 = VNode(component: AView())
            n0.appendChild(n1_1)
            let n2_1 = VNode.tag("p")
            n1_1.appendChild(n2_1)
            
            XCTAssertNil(try n2_0.prevSiblingTagNode)
            XCTAssertIdentical(try n2_1.prevSiblingTagNode, n2_0)
        }
    }
}
