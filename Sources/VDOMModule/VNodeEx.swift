extension VNode {
    public var parentTagNode: VTagNode? {
        get {
            var nodeO: VParentNode? = self.parent
            while true {
                guard let node = nodeO else {
                    return nil
                }

                if let node = node as? VTagNode {
                    return node
                }

                nodeO = node.parent
            }
        }
    }

    public var prevSiblingTagNode: VTagNode? {
        get throws {
            guard let parent = self.parent else {
                return nil
            }

            let selfIndex = try parent.children.firstIndex(where: { $0 === self }).unwrap("index")

            for index in stride(from: selfIndex - 1, through: 0, by: -1) {
                let node = parent.children[index]

                var found: VTagNode? = nil

                node.walk { (node) in
                    if let node = node as? VTagNode {
                        found = node
                        return .break
                    }

                    return .continue
                }

                if let found {
                    return found
                }
            }

            if parent is VTagNode {
                return nil
            }

            return try parent.prevSiblingTagNode
        }
    }

    // TODO: remove unused this
    public var shallowTagNodes: [VTagNode] {
        var result: [VTagNode] = []

        walk { (node) in
            if let node = node as? VTagNode {
                result.append(node)
                return .skipChildren
            }

            return .continue
        }

        return result
    }

    public enum WalkControl {
        case `continue`
        case skipChildren
        case `break`
    }

    @discardableResult
    public func walk(step: (VNode) -> WalkControl) -> WalkControl {
        let c: Bool
        switch step(self) {
        case .continue:
            c = true
        case .skipChildren:
            c = false
        case .break: return .break
        }

        if c, let p = self as? VParentNode {
            for x in p.children {
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
