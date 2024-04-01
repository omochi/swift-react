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
        dom as? JSHTMLElement
    }

    public var domText: JSText? {
        dom as? JSText
    }

    public var parentTagNode: VNode? {
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

    public var prevSiblingTagNode: VNode? {
        get throws {
            guard let parent = self.parent else {
                return nil
            }

            let selfIndex = try parent.index(of: self).unwrap("index")

            for index in stride(from: selfIndex - 1, through: 0, by: -1) {
                let node = parent.children[index]

                var found: VNode? = nil

                node.walk { (node) in
                    if node.tagElement != nil ||
                        node.textElement != nil
                    {
                        found = node
                        return .break
                    }

                    return .continue
                }

                if let found {
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

    @discardableResult
    public func walk(step: (VNode) -> WalkControl) -> WalkControl {
        let doesWalkChildren: Bool
        switch step(self) {
        case .continue:
            doesWalkChildren = true
        case .skipChildren:
            doesWalkChildren = false
        case .break: return .break
        }

        if doesWalkChildren {
            for x in children {
                switch x.walk(step: step) {
                case .continue,
                        .skipChildren: continue
                case .break: return .break
                }
            }
        }

        return .continue
    }
}
