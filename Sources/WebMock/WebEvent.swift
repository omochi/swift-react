import JavaScriptKitMock

public class WebEvent: JSNativeObject {
    public init(
        _ type: String
    ) {
        self.type = type
    }

    public let type: String
}
