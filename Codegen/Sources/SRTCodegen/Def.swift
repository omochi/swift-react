import Collections

struct Def: Codable {
    var tagNames: [String]
    var voidElements: [String]
    var elementAttributes: [String: [String]]

    mutating func fix() {
        tagNames.removeAll { (tagName) in
            voidElements.contains(tagName)
        }
    }

    var allAttributes: [String] {
        var attrs: OrderedSet<String> = []
        attrs.formUnion(elementAttributes["*"] ?? [])

        var dict = elementAttributes
        dict["*"] = nil

        for key in dict.keys.sorted() {
            attrs.formUnion(dict[key] ?? [])
        }

        return attrs.elements
    }
}
