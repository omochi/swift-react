extension Optional {
    public func unwrap(_ name: String) throws -> Wrapped {
        guard let x = self else {
            throw NoneError(name)
        }
        return x
    }
}
