import Foundation

public struct MessageError: LocalizedError & CustomStringConvertible {
    public init(
        _ message: String
    ) {
        self.message = message
    }

    public var message: String

    public var description: String { message }
    public var errorDescription: String? { message }
}
