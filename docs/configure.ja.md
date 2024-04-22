# 環境構築方法

Swift React を使ったアプリケーションを実行できるようにするには、以下の準備が必要です。

## ホスト環境の構築

ホスト環境に `wasm-opt` コマンドが必要です。 Homebrew で binaryen パッケージをインストールしてください。

```sh
$ brew install binaryen
```

---

## プロジェクトの構築

プロジェクトは SwiftPM Package として構築します。
アプリケーションは executable として設定してください。

依存ライブラリとして Swift React を追加してください。

```swift
.package(url: "https://github.com/omochi/swift-react", from: "0.1.0")
```

そして、 `React` モジュールをターゲットに追加してください。

ビルドするためにはここから特別な手順が必要です。

## ビルドの構築

ビルドの構築においては2つの方法があります。

1つは [carton](https://github.com/swiftwasm/carton) を利用する方法です。
もう一つは必要なものを全て自分で構築する方法です。
それぞれ説明します。

## Carton を利用してビルドする方法

> [!CAUTION]
> 残念ながら現在の Carton では Swift React をビルドできません。
> Carton が Swift 5.10 に対応するのを待ちましょう。
> 以下の文章は、対応された想定で書かれています。

あなたのプロジェクトの依存ライブラリとして Carton を追加します。

```swift
.package(url: "https://github.com/swiftwasm/carton", from: "1.0.3")
```

こうすることで、 Carton のコマンドラインツールがプロジェクトで利用できます。ライブラリとしてターゲットに組み込む必要はありません。

プロジェクトルートで以下のコマンドを実行します。

```sh
$ swift run carton dev
```

これでプロジェクトのビルド、ウェブサーバのホスト、ブラウザの起動が自動で行われて、あなたのアプリケーションが表示されます。その他のコマンドについては [Carton#420](https://github.com/swiftwasm/carton/pull/420) を参照してください。

### 構成例

実際に構成した例として [CartonExample](../CartonExample) を参照してください。

## 自分でビルドする方法

### Wasm に対応した Swift の入手

まずは、WASM に対応したコンパイラを手に入れます。
[Swiftのダウンロードページ](https://www.swift.org/download/)の、 Snapshots セクションのうち、 Trunk Development (main) の部分を参照します。 Xcode の行に書いてある Universal というリンクからインストーラをダウンロードできます。

インストールウィザードにおいて、インストール先を選ぶ場面では「自分だけにインストール」を選んでください。

インストールしたら、以下のコマンドによってパッケージのバンドルIDを取得してください。

```sh
plutil -extract CFBundleIdentifier raw \
  ~/Library/Developer/Toolchains/swift-latest.xctoolchain/Info.plist
```

通常、バンドルIDは以下のような形式の文字列です。

```
org.swift.59202404021a
```

これをどこかに記録しておいてください。

### Wasm に対応した Swift への切り替え

ビルドをする時は、 Wasm に対応した Swift に切り替えます。
下記のように `TOOLCHAINS` 環境変数に対してバンドルIDを指定します。

```sh
export TOOLCHAINS=org.swift.59202404021a
```

### Wasm SDK の入手

Swift コンパイラツールチェーンに対して、 Wasm SDK を追加します。

[Swift for Wasm のリポジトリ](https://github.com/swiftwasm/swift) から、あなたがインストールした Swift snapshot と同じ日付の、 Swift for Wasm snapshot のリリースページを探します。これは以下のようなURLをしているので、日付の部分を編集してアクセスしてください。

[https://github.com/swiftwasm/swift/releases/tag/swift-wasm-DEVELOPMENT-SNAPSHOT-2024-04-03-a](https://github.com/swiftwasm/swift/releases/tag/swift-wasm-DEVELOPMENT-SNAPSHOT-2024-04-03-a)

リリースページの Assets のセクションから、あなたの mac 向けの artifact bundle を探します。
CPUアーキテクチャは arm64 と x86_64 の2つがあるので適切な方を選んでください。
また、pkg ではなく artifact bundle を選んでください。artifact bundle の中に SDK が入っています。

そのリンクを右クリックして、 SDK のダウンロードURLを取得します。

以下のコマンドを実行して、SDK をインストールします。

```sh
$ swift experimental-sdk install <SDK download URL>
```

### Wasm アプリケーションのビルド

以下のコマンドでビルドします。

```sh
$ swift build --experimental-swift-sdk wasm32-unknown-wasi \
  --disable-build-manifest-caching \
  -Xswiftc -static-stdlib \
  -Xswiftc -Xclang-linker -Xswiftc -mexec-model=reactor \
  -Xlinker --export-if-defined=__main_argc_argv \
  -Xlinker --stack-first \
  -Xlinker --global-base=1048576 \
  -Xlinker -z -Xlinker stack-size=1048576
```

成功すると、ビルドディレクトリに wasm ファイルが生成されます。

```sh
$ ls .build/wasm32-unknown-wasi/debug/*.wasm
```

実行時においては、この wasm ファイルをブラウザから読み込んでアプリケーションを起動します。
よって、この wasm ファイルをなんらかの方法でホスティングする必要があります。

### JavaScriptKit のランタイムライブラリの入手

実行時において、 JavaScriptKit のランタイムライブラリをロードする必要があります。
これは JavaScript で書かれています。

ビルドが成功したら、ビルドディレクトリの以下のパスにビルド済みのランタイムライブラリが配置されています。

```sh
$ ls .build/wasm32-unknown-wasi/debug/JavaScriptKit_JavaScriptKit.resources/Runtime
```

`index.js` と `index.mjs` の2種類があり、モジュールモードが違います。
あなたのJavaScriptプロジェクトにおいて適切なものを利用します。

もしくは、ランタイムライブラリのソースを自分でビルドすることもできます。
これは TypeScript で実装されています。
これは以下のパスに配置されています。

```sh
$ ls .build/checkouts/JavaScriptKit/Runtime
```

### 起動スクリプトの実装

ウェブサイトが表示されたら、スクリプトを利用して wasm のロードと実行をする必要があります。
またその際に、 JavaScriptKit のランタイムライブラリを wasm にインポートする必要があります。

ここでは [Carton の実装](https://github.com/swiftwasm/carton/blob/main/entrypoint/bundle.ts) が参考になるでしょう。

### エントリページの実装

HTMLを用意します。これが起動スクリプトを読み込むようにしましょう。

### ページとリソースのホスト

エントリページ、起動スクリプト、JavaScriptKitランタイム、wasmバイナリを全て適切なパスでホストしましょう。
ブラウザからアクセスすれば Swift React アプリケーションが動くはずです。

### 構成例

実際に構成した例として [BrowserTests](../BrowserTests) が参考になるでしょう。
