import SRTDOM

public struct JSNodeLocationLeft: Hashable {
    public init(
        parent: JSNode,
        next: JSNode?
    ) {
        self.parent = parent
        self.next = next
    }

    public var parent: JSNode

    // nil means end of children
    public var next: JSNode?
}

public struct JSNodeLocationRight: Hashable {
    public init(
        parent: JSNode,
        prev: JSNode?
    ) {
        self.parent = parent
        self.prev = prev
    }
    
    public var parent: JSNode

    // nil means start of children
    public var prev: JSNode?

    public func toLeft(`self`: (any JSNodeProtocol)?) -> JSNodeLocationLeft {
        var next: JSNode? = if let prev {
            prev.nextSibling
        } else {
            parent.firstChild
        }

        while true {
            if let n = next, n == `self`?.asNode() {
                next = n.nextSibling
            } else { 
                break
            }
        }
        
        return JSNodeLocationLeft(parent: parent, next: next)
    }
}

extension JSNodeProtocol {
    public func insert(at location: JSNodeLocationLeft) throws {
        try location.parent.insertBefore(self, location.next)
    }

    public func insert(at location: JSNodeLocationRight) throws {
        let location = location.toLeft(self: self)
        try insert(at: location)
    }

    public var locationLeft: JSNodeLocationLeft? {
        guard let parent = parentNode else { return nil }

        return JSNodeLocationLeft(
            parent: parent,
            next: nextSibling
        )
    }

    public var locationRight: JSNodeLocationRight? {
        guard let parent = parentNode else { return nil }

        return JSNodeLocationRight(
            parent: parent,
            prev: previousSibling
        )
    }
}
