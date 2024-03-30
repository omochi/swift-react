public final class WebMutableNodeList: WebNodeList {
    public override init() {
        self._items = []
    }

    internal override var items: [WebNode] { _items }

    internal var _items: [WebNode]
}
