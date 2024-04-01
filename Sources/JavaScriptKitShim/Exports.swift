#if canImport(JavaScriptKitMock)
@_exported import JavaScriptKitMock
#elseif canImport(JavaScriptKit)
@_exported @_spi(JSObject_id) import JavaScriptKit

extension JSObject: Hashable {
    public func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
}
#endif
