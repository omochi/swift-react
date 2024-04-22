# Swift React

**Swift React** は [React](https://react.dev) を Swift で新規に実装したライブラリです。これを使って Swift でインタラクティブなウェブサイトを実装しましょう。

## 概要

**Swift React** は React と同じように使えることを目指しています。ただし API は Swift らしい仕様にしています。以下は Hello world を表示する実装例です。

```swift
import React

struct App: Component {
    func render() -> Node {
        div {
            "Hello World"
        }
    }
}
```

### 対象環境

Swift for WASM を対象にしています。他の Swift 環境はサポートしていません。

ウェブブラウザ上での実行を対象にしています。他の WASM 実行環境はサポートしていません。

## 利用方法

Swift Packageから依存ライブラリとして追加してください。

```swift
.package(url: "https://github.com/omochi/swift-react", from: "0.1.0")
```

[JavaScriptKit](https://github.com/swiftwasm/JavaScriptKit) に依存しているので、ウェブブラウザ上でWASMバイナリをロードする際に、 JavaScriptKit の JavaScript ランタイムライブラリをインポートする必要があります。詳しくは [環境構築方法](./docs/configure.ja.md)を参照してください。

## 文書

- [環境構築方法](./docs/configure.ja.md)
- [APIの実装状況](./docs/api.md)

### 開発者向け

- [Testing](./docs/testing.md)


