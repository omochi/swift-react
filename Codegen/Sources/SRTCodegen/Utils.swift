import Foundation

public let keywords = [
    "as",
    "class",
    "default",
    "defer",
    "for",
    "is",
    "var",
]

func renderIdentifier(_ text: String) -> String {
    var text = text
    if keywords.contains(text) {
        text = "`\(text)`"
    }
    return text
}

extension String {
    func kebabToCamel() -> String {
        let strs = self.components(separatedBy: "-")

        var result = ""
        for (index, str) in strs.enumerated() {
            if index == 0 {
                result += str.lowercased()
            } else {
                result += str.capitalized
            }
        }

        return result
    }
}
