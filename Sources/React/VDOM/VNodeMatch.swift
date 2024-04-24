enum VNodeKind: Hashable {
    case html(String)
    case text
    case component(ObjectIdentifier)
}

extension Component {
    var vnodeKind: VNodeKind {
        switch self {
        case let html as HTMLElement: .html(html.tagName)
        case is TextElement: .text
        default: .component(ObjectIdentifier(type(of: self)))
        }
    }

    var vnodeDiscriminator: VNodeDiscriminator {
        VNodeDiscriminator(kind: vnodeKind, key: key)
    }
}

struct VNodeDiscriminator: Hashable {
    init(
        kind: VNodeKind,
        key: AnyHashable?
    ) {
        self.kind = kind
        self.key = key
    }
    
    var kind: VNodeKind
    var key: AnyHashable?
}

struct VNodeMatchAdapter: Hashable {
    init(node: VNode) {
        self.node = node
        self.disc = node.component.vnodeDiscriminator
    }

    var node: VNode
    let disc: VNodeDiscriminator

    static func ==(a: Self, b: Self) -> Bool { a.disc == b.disc }

    func hash(into hasher: inout Hasher) {
        hasher.combine(disc)
    }
}

extension VNode {
    static func match(newChildren: [VNode], oldChildren: [VNode]) -> CollectionDifference<VNode> {
        matchStdlib(newChildren: newChildren, oldChildren: oldChildren)
    }

    static func matchStdlib(newChildren: [VNode], oldChildren: [VNode]) -> CollectionDifference<VNode> {
        let newChildren = newChildren.map { VNodeMatchAdapter(node: $0) }
        let oldChildren = oldChildren.map { VNodeMatchAdapter(node: $0) }

        let diff: CollectionDifference<VNodeMatchAdapter> = newChildren
            .difference(from: oldChildren)
            .inferringMoves()

        return CollectionDifference<VNode>(
            diff.map { (patch) in
                switch patch {
                case .remove(offset: let o, element: let e, associatedWith: let a):
                    .remove(offset: o, element: e.node, associatedWith: a)
                case .insert(offset: let o, element: let e, associatedWith: let a):
                    .insert(offset: o, element: e.node, associatedWith: a)
                }
            }
        )!
    }
}
