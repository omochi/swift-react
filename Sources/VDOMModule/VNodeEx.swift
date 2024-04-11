import SRTDOM
import ReactInterface

extension VNode {
    public var tagElement: TagElement? {
        ghost.component as? TagElement
    }

    package var textElement: TextElement? {
        ghost.component as? TextElement
    }

    public var domTag: JSHTMLElement? {
        dom?.asHTMLElement()
    }

    public var domText: JSText? {
        dom?.asText()
    }

    // unused
    package var parentTagNode: VNode? {
        get {
            var nodeO: VNode? = self.parent
            while true {
                guard let node = nodeO else {
                    return nil
                }

                if node.tagElement != nil {
                    return node
                }

                nodeO = node.parent
            }
        }
    }

    // unused
    package var prevSiblingTagNode: VNode? {
        get throws {
            guard let parent = self.parent else {
                return nil
            }

            let selfIndex = try parent.index(of: self).unwrap("index")

            for index in stride(from: selfIndex - 1, through: 0, by: -1) {
                let node = parent.children[index]

                if let found = node.find(
                    direction: .left, 
                    predicate: { (node) in
                        node.tagElement != nil ||
                        node.textElement != nil
                    }
                ) {
                    return found
                }
            }

            if parent.tagElement != nil {
                return nil
            }

            return try parent.prevSiblingTagNode
        }
    }

    public enum WalkControl {
        case `continue`
        case skipChildren
        case `break`
    }

    public enum WalkDirection {
        case right
        case left
    }

    @discardableResult
    public func walk(
        direction: WalkDirection = .right,
        step: (VNode) -> WalkControl
    ) -> WalkControl {
        let doesWalkChildren: Bool
        switch step(self) {
        case .continue:
            doesWalkChildren = true
        case .skipChildren:
            doesWalkChildren = false
        case .break: return .break
        }

        if doesWalkChildren {
            let children: [VNode] = switch direction {
            case .right: self.children
            case .left: self.children.reversed()
            }

            for x in children {
                switch x.walk(
                    direction: direction,
                    step: step
                ) {
                case .continue,
                        .skipChildren: continue
                case .break: return .break
                }
            }
        }

        return .continue
    }

    public func find(
        direction: WalkDirection = .right,
        predicate: (VNode) -> Bool
    ) -> VNode? {
        var result: VNode? = nil
        walk(direction: direction) { (node) in
            if predicate(node) {
                result = node
                return .break
            }
            return .continue
        }
        return result
    }
}
