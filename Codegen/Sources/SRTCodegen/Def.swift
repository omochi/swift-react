import Collections

struct Def: Codable {
    var tagNames: [String]
    var voidElements: [String]
    var elementAttributes: [String: [String]]
    var eventAttributes: [String]
    var cssProperties: [String]

    mutating func fix() {
        tagNames.removeAll { (tagName) in
            voidElements.contains(tagName)
        }

        self.cssProperties = {
            var css: OrderedSet<String> = []
            
            for x in cssProperties {
                if !x.hasPrefix("-") {
                    css.remove("-" + x)
                }

                css.append(x)
            }

            return css.elements
        }()
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
