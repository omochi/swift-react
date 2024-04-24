enum VNodeKind: Hashable {
    case html(String)
    case text
    case component(ObjectIdentifier)
}

struct VNodeDiscriminator: Hashable {
    public init(
        kind: VNodeKind,
        key: AnyHashable?
    ) {
        self.kind = kind
        self.key = key
    }
    
    public var kind: VNodeKind
    public var key: AnyHashable?
}

struct VNodeMatchRemove {
    var offset: Int
    var node: VNode
    var isMove: Bool
}

struct VNodeMatchInsert {
    var offset: Int
    var newNode: VNode
    var oldNode: VNode?
}

struct VNodeMatch {
    var removes: [VNodeMatchRemove]
    var inserts: [VNodeMatchInsert]
}

extension VNode {
    static func match(newChildren: [VNode], oldChildren: [VNode]) -> VNodeMatch {
        matchStdlib(newChildren: newChildren, oldChildren: oldChildren)
    }

    static func matchFast(newChildren: [VNode], oldChildren: [VNode]) {
        var oldDest: [Int?] = Array(repeating: nil, count: oldChildren.count)
        var newSource: [Int?] = Array(repeating: nil, count: newChildren.count)

        var newKeyTable: [VNodeDiscriminator: Int] = [:]
        for (index, new) in newChildren.enumerated() {
            if new.discriminator.key != nil,
               newKeyTable[new.discriminator] == nil
            {
                newKeyTable[new.discriminator] = index
            }
        }

        for (oldIndex, old) in oldChildren.enumerated() {
            if old.discriminator.key != nil {
                if let newIndex = newKeyTable[old.discriminator] {
                    oldDest[oldIndex] = newIndex
                    newSource[newIndex] = oldIndex
                }
            }
        }

        var newTable: [VNodeDiscriminator: [Int]] = [:]
        for (index, new) in newChildren.enumerated() {
            if newSource[index] != nil { continue }
            newTable[new.discriminator, default: []].append(index)
        }

        for (oldIndex, old) in oldChildren.enumerated() {
            if oldDest[oldIndex] != nil { continue }

            if var array = newTable[old.discriminator], !array.isEmpty {
                let newIndex = array.removeFirst()
                newTable[old.discriminator] = array
                
                oldDest[oldIndex] = newIndex
                newSource[newIndex] = oldIndex
            }
        }

        for (oldIndex, old) in oldChildren.enumerated().reversed() {
            if oldDest[oldIndex] == nil {
                // remove operation

                // offset
                newSource = newSource.map { (source) in
                    if let source,
                       source >= oldIndex
                    {
                        return source - 1
                    } else {
                        return source
                    }
                }
            }
        }

        // ...?
    }

    static func matchStdlib(newChildren: [VNode], oldChildren: [VNode]) -> VNodeMatch {
        let diff = newChildren
            .difference(from: oldChildren)
            .inferringMoves()

        var removes: [VNodeMatchRemove] = []
        var inserts: [VNodeMatchInsert] = []

        for patch in diff {
            switch patch {
            case .remove(offset: let offset, element: let oldNode, associatedWith: let dest):
                let x = VNodeMatchRemove(
                    offset: offset,
                    node: oldNode,
                    isMove: dest != nil
                )
                removes.append(x)
            case .insert(offset: let offset, element: let newNode, associatedWith: let source):
                let x = VNodeMatchInsert(
                    offset: offset,
                    newNode: newNode,
                    oldNode: source.map { oldChildren[$0] }
                )
                inserts.append(x)
            }
        }

        return VNodeMatch(removes: removes, inserts: inserts)
    }
}
