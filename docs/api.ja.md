# API マニュアル

## Component

コンポーネントを実装するには Component に準拠した型を定義し、 render メソッドを実装します。

```swift
struct App: Component {
    func render() -> Node {
        div { "Hello World" }
    }
}
```

コンポーネントが再描画の際に兄弟同士で同一性を決定できるようにするには、 key プロパティを実装します。
複数個表示される事があるコンポーネントでは、パフォーマンス改善のためにも実装してください。
将来はマクロで自動実装する事を検討しています。

```swift
struct App: Component {
    var key: AnyHashable?

    func render() -> Node { ... }
}
```

コンポーネントが同値性に基づいて render を省略できるようにするには、 deps プロパティを実装します。
これにはフック以外のプロパティを全て含めてください。keyも含めてください。
将来はマクロで自動実装する事を検討しています。

```swift
struct App: Component {
    var key: AnyHashable?

    var count: Int

    var deps: Deps? {
        [key, count]
    }
}
```

子供要素を受け取れるコンポーネントにしたい場合は、それを `[Node]` 型のプロパティに保存してください。
init では `ChildrenBuilder` を使って受け取ってください。

```swift
struct Box: Component {
    init(children: @ChildrenBuilder children: () -> [Node] = { [] }) {
        self.children = children
    }

    var children: [Node]

    func render() -> Node {
        div { children }
    }
}

子供要素を `deps` に含めるときは、 `[Node].deps` プロパティを利用してください。

```swift
struct Box: Component {
    ...

    var deps: Deps? {
        [key, children.deps]
    }
}
```

## ReactRoot

コンポーネントを HTML に反映するための型です。
init で対象の HTML を受け取り、 render でコンポーネントを受け取ります。

```swift
let body = JSWindow.global.document.body
let root = ReactRoot(element: body)
root.render(component)
```

画面更新のために render を再び呼び出すことができますが、通常は必要ありません。

Wasm のエントリポイントの脱出後にこのオブジェクトが解放されることがないように、
グローバル変数に保存してください。

## HTML タグ

HTML タグはそのタグ名の関数で記述します。

```swift
div {
    p { "title" }
    button { "push me" }
}
```

兄弟間での同一性は `key` プロパティで指定します。

```swift
div {
    users.map { (user) in 
        div(key: user.id) {
            user.name
        }
    }
}
```

アトリビュートは、 `attributes` プロパティで渡します。

```swift
div(
    attributes: [
        "class": "title-box"
    ]
)
```

`style` アトリビュートを使ってインラインスタイルを与えられます。

```swift
div(
    attributes: [
        "style": """
            width: 100%;
            margin: 4px;
        """
    ]
)
```

イベントリスナーは、 `listeners` プロパティで渡します。
キーとしてイベント名を指定します。

```swift
button(
    listeners: [
        "click": Function { (ev) in 
            print("clicked!") 
        }
    ]
)
```

## Fragment

複数のコンポーネントを並べるときに、HTMLタグに包みたくない場合は、Fragmentを使います。

```swift
Fragment {
    div { "1" }
    div { "2" }
}
```

## Function

関数は `Function` 型に包んで使います。
型パラメータとして、返り値の型と、引数の型を取ります。

```swift
let intToString = Function<String, Int> { $0.description }
print(intToString(123))
```

これは参照型で、同一性が同値性になっているため、
コンポーネントのコールバック引数として使用すると、
deps による同値性判定ができます。

## EventListener

EventListener 型は、引数が `JSEvent` 、返り値が `Void` の　`Function` です。

# Hook

以下のフックが提供されています。

## State

状態を保持できます。書き込むと再描画されます。

```swift
struct Box: Component {
    @State var count: Int = 0

    func render() -> Node {
        div {
            count
            Button(onClick: Function {
                count += 1
            })
        }
    }
}
```

## Ref

状態を保持したり、HTML Tag の実DOMを取得したりできます。
書き込み時の再描画はされません。
参照として利用する際は `$` を付けます。

```swift
struct Box: Component {
    @Ref var buttonRef: JSHTMLElement?

    func render() -> Node {
        div(ref: $buttonRef)
    }
}
```

## Context

パラメータを外部から注入できます。

まず、パラメータの型を `ContextValue` に準拠します。
これは `defaultValue` が必要です。

```swift
struct Theme: ContextValue {
    static var defaultValue: Theme { .init(name: "light") }

    var name: String
}
```

次に、上流のコンポーネントで `Provider` を使って値を注入します。

```swift
struct App: Component {
    func render() -> Node {
        Context.Provider(value: Theme(name: "dark")) {
            Box()
        }
    }
}
```

最後に、下流のコンポーネントで `@Context` を使って値を受け取ります。

```swift
struct Box: Component {
    @Context var theme: Theme

    func render() -> Node {
        div(attributes: [
            "class": "box-\(theme.name)"
        ]) {
            "hello"
        }
    }
}
```

上流で値の更新があると、値を受け取っている下流のコンポーネントが再描画されます。

## Callback

関数の同一性を担保できます。
`$` 付きの呼び出して関数の実装を定義します。
`deps` が変化しない限り、同じ `Function` オブジェクトを維持します。

```swift
struct Box: Component {
    var count = 0

    @Callback var onClick: Function<Void>

    func render() -> Node {
        $onClick(deps: [count]) { () in
            print("onClick at \(count)")
        }

        return Button(onClick: onClick)
    }
}
```

## Effect

副作用を扱えます。
`$` 付きの呼び出しでセットアップとクリーンアップをセットで登録します。
コンポーネントが生成される時にセットアップが呼ばれ、破棄される時にクリーンアップが呼ばれます。
また、 `deps` が変化すると クリーンアップとセットアップが順に呼ばれます。

```swift
struct Box: Component {
    var count = 0

    @Effect var effect

    func render() -> Node {
        $effect(deps: [count]) {
            print("setup")
            return {
                print("cleanup")
            }
        }
    }
}
```
