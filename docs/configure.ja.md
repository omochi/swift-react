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

まずは、Wasm に対応したコンパイラを手に入れます。
[Swiftのダウンロードページ](https://www.swift.org/download)の、 Snapshots セクションのうち、 Trunk Development (main) の部分を参照します。 Xcode の行に書いてある Universal というリンクからインストーラをダウンロードできます。この時ダウンロードしたファイル名に含まれる、 Swift の git タグを確認しておいてください。例えば `swift-DEVELOPMENT-SNAPSHOT-2024-04-27-a-osx.pkg` の場合は、末尾の `-osx.pkg` を取り除いた `swift-DEVELOPMENT-SNAPSHOT-2024-04-27-a` がタグです。

インストールウィザードにおいて、インストール先を選ぶ場面では「自分だけにインストール」を選んでください。

インストールしたら、以下のコマンドによってパッケージのバンドルIDを取得してください。

```sh
plutil -extract CFBundleIdentifier raw \
  ~/Library/Developer/Toolchains/swift-latest.xctoolchain/Info.plist
```

通常、バンドルIDは以下のような形式の文字列です。

```
org.swift.59202404271a
```

これをどこかに記録しておいてください。

### Wasm に対応した Swift への切り替え

ビルドをする時は、 Wasm に対応した Swift に切り替えます。
下記のように `TOOLCHAINS` 環境変数に対してバンドルIDを指定します。

```sh
export TOOLCHAINS=org.swift.59202404271a
```

### Wasm SDK の入手

Swift コンパイラツールチェーンに対して、 Wasm SDK を追加します。

[Swift for Wasm の Release ページ](https://github.com/swiftwasm/swift/releases) から、あなたがインストールした Swift に対応する Swift for Wasm を探します。個別のリリースページには `apple/swift` のバージョンが書かれているので、これが Swift の git タグと一致しているリリースを探します。例えばタグが `swift-DEVELOPMENT-SNAPSHOT-2024-04-27-a` であれば、以下のリリースが対応しています。

https://github.com/swiftwasm/swift/releases/tag/swift-wasm-DEVELOPMENT-SNAPSHOT-2024-04-28-a

一般的には、 Swift のスナップショットの次の日付になっているスナップショットが対応しているようです。

対応しているリリースページがわかったら、 Assets のセクションから、Wasm 向けの Swift SDK を含む artifact bundle を探します。ファイル名の末尾が `wasm32-unknown-wasi.artifactbundle.zip` となっているものを選びます。 似た名前の `wasm32-unknown-wasip1-threads.artifactbundle.zip` もありますが、こちらは違うので注意しましょう。

そのリンクを右クリックして、 SDK のダウンロードURLを取得します。例えば以下のような URL でしょう。

https://github.com/swiftwasm/swift/releases/download/swift-wasm-DEVELOPMENT-SNAPSHOT-2024-04-28-a/swift-wasm-DEVELOPMENT-SNAPSHOT-2024-04-28-a-wasm32-unknown-wasi.artifactbundle.zip

この URL を 以下の SDK インストール用のコマンドに渡すことでインストールします。

```sh
$ swift sdk install <SDK download URL>
```

### Wasm アプリケーションのビルド

以下のコマンドでビルドします。

```sh
$ swift build --swift-sdk wasm32-unknown-wasi \
  --disable-build-manifest-caching \
  --static-swift-stdlib \
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

---

## テンプレートを利用してプロジェクトを構築する

プロジェクトテンプレートを使用すれば構築済みの状態から始めることができます。

- [omochi-template](https://github.com/omochi/swift-react-omochi-template): Carton を使わず、Vite で構築しています。独自のホットリロードを実装しています。

