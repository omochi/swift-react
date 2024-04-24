import SRTDOM

extension VNode {
    public var htmlElement: HTMLElement? {
        component as? HTMLElement
    }

    public var textElement: TextElement? {
        component as? TextElement
    }

    public var parentTagNode: VNode? {
        get {
            var nodeO: VNode? = self.parent
            while true {
                guard let node = nodeO else {
                    return nil
                }

                if node.htmlElement != nil {
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

                if let found = node.find(
                    direction: .left, 
                    predicate: { (node) in
                        node.htmlElement != nil ||
                        node.textElement != nil
                    }
                ) {
                    return found
                }
            }

            if parent.htmlElement != nil {
                return nil
            }

            return try parent.prevSiblingTagNode
        }
    }

    public var domChildren: [JSNode] {
        get {
            var doms: [JSNode] = []

            walk { (node) in
                if let dom = node.instance?.dom {
                    doms.append(dom)
                    return .skipChildren
                }

                return .continue
            }

            return doms
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
