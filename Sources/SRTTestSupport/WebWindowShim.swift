import SRTJavaScriptKitEx

#if USES_JAVASCRIPT_KIT_MOCK
@_exported import class WebMock.WebWindow
#else
public final class WebWindow {
    public static func initializeJavaScriptKit() {
        // do nothing
    }
}
#endif
