struct Def: Codable {
    var tagNames: [String]
    var voidElements: [String]
    var elementAttributes: [String: [String]]

    mutating func fix() {
        tagNames.removeAll { (tagName) in
            voidElements.contains(tagName)
        }
    }
}
