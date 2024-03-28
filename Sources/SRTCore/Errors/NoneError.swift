import Foundation

public struct NoneError: LocalizedError & CustomStringConvertible {
    public init(
        _ name: String
    ) {
        self.name = name
    }

    public var name: String

    public var description: String { "\(name) is none" }
    public var errorDescription: String? { description }
}
