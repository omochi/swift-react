import ReactInterface

extension VNode {
    public var tagElement: TagElement? {
        component as? TagElement
    }

    public var parentTagNode: VNode? {
        get {
            var nodeO: VNode? = self.parent
            while true {
                guard let node = nodeO else {
                    return nil
                }

                if let _ = node.tagElement {
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
                    if let _ = node.tagElement {
                        found = node
                        return .break
                    }

                    return .continue
                }

                if let found {
                    return found
                }
            }

            if let _ = parent.tagElement {
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
