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
                        return false
                    }

                    return true
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

    @discardableResult
    public func walk(step: (VNode) -> Bool) -> Bool {
        guard step(self) else { return false }

        if let p = self as? VParentNode {
            for x in p.children {
                guard x.walk(step: step) else { return false }
            }
        }

        return true
    }
}
