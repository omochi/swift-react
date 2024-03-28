import XCTest
import SRTTestSupport
import ReactInterface
import VDOMModule

final class VNodeTests: XCTestCase {

    struct AView: ReactComponent {
        func render() -> (any ReactNode)? { nil }
    }

    func testParentTag() {
        do {
            let n0 = VTagNode(tagName: "div")
            XCTAssertNil(n0.parentTagNode)
        }

        do {
            let n0 = VTagNode(tagName: "div")
            let n1 = VTagNode(tagName: "p")
            n0.appendChild(n1)
            XCTAssertIdentical(n1.parentTagNode, n0)
        }

        do {
            let n0 = VTagNode(tagName: "div")
            let n1 = VComponentNode(component: AView())
            n0.appendChild(n1)
            let n2 = VTagNode(tagName: "p")
            n1.appendChild(n2)
            XCTAssertIdentical(n2.parentTagNode, n0)
        }
    }

    func testPrevSiblingTag() throws {
        do {
            let n0 = VTagNode(tagName: "div")
            let n1_0 = VTagNode(tagName: "p")
            n0.appendChild(n1_0)
            let n1_1 = VTagNode(tagName: "p")
            n0.appendChild(n1_1)
            XCTAssertNil(try n0.prevSiblingTagNode)
            XCTAssertNil(try n1_0.prevSiblingTagNode)
            XCTAssertIdentical(try n1_1.prevSiblingTagNode, n1_0)
        }

        do {
            let n0 = VTagNode(tagName: "div")
            let n1_0 = VComponentNode(component: AView())
            n0.appendChild(n1_0)
            let n2_0 = VTagNode(tagName: "p")
            n1_0.appendChild(n2_0)

            let n1_1 = VComponentNode(component: AView())
            n0.appendChild(n1_1)
            let n2_1 = VTagNode(tagName: "p")
            n1_1.appendChild(n2_1)
            
            XCTAssertNil(try n2_0.prevSiblingTagNode)
            XCTAssertIdentical(try n2_1.prevSiblingTagNode, n2_0)
        }
    }

    func testShallowTagNodes() throws {
        do {
            let n0 = VTagNode(tagName: "div", children: [
                VTagNode(tagName: "p"),
                VTagNode(tagName: "p"),
            ])

            XCTAssertArrayIdentical(n0.shallowTagNodes, [n0])
        }

        do {
            let n0 = VComponentNode(component: AView())
            let n1 = VTagNode(tagName: "div")
            n0.appendChild(n1)
            let n2 = VComponentNode(component: AView())
            n0.appendChild(n2)
            let n3 = VTagNode(tagName: "div")
            n2.appendChild(n3)
            let n4 = VTagNode(tagName: "div")
            n2.appendChild(n4)

            XCTAssertArrayIdentical(n0.shallowTagNodes, [n1, n3, n4])
        }
    }
}
