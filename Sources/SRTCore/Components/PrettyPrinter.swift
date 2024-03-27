public final class PrettyPrinter {
    public init() {}

    public var indent: String = "    "
    public private(set) var output: String = ""
    public private(set) var isStartOfLine: Bool = true
    private var depth: Int = 0

    public func write(
        space: String? = nil,
        _ text: String,
        newline: Bool = false
    ) {
        if let space {
            write(space: space)
        }

        write(text)

        if newline {
            writeNewline()
        }
    }

    public func write(space: String) {
        if !isStartOfLine {
            write(space)
        }
    }

    public func write(_ text: String) {
        if text.isEmpty { return }

        if isStartOfLine {
            writeIndent()
        }

        output += text
    }

    public func writeNewline() {
        output += "\n"
        isStartOfLine = true
    }

    public func push() {
        writeNewline()
        depth += 1
    }

    public func pop() {
        if !isStartOfLine {
            writeNewline()
        }
        depth -= 1
    }

    public func nest<R>(_ body: () throws -> R) rethrows -> R {
        push()
        defer { pop() }
        return try body()
    }

    public func nestIf<R>(condition: Bool, _ body: () throws -> R) rethrows -> R {
        if condition {
            return try nest(body)
        } else {
            return try body()
        }
    }

    private func writeIndent() {
        output += String(repeating: indent, count: depth)
        isStartOfLine = false
    }
}
