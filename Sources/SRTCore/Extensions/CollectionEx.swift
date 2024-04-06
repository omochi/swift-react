extension Collection {
    public subscript(safe index: Index) -> Element? {
        guard startIndex..<endIndex ~= index else { return nil }
        return self[index]
    }
}
