public struct AnyDeps: Hashable {
    public init<each T: Hashable>(_ items: repeat each T) {
        var boxes: [AnyHashable] = []
        repeat boxes.append(each items)
        self.items = boxes
    }

    var items: [AnyHashable]
}
