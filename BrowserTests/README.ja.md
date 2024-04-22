# Browser Tests

このプロジェクトは Swift React をブラウザ上で実行させて手動でテストするためのものです。

実装されている React アプリケーションは [React 公式ドキュメント](https://ja.react.dev/learn) に出てくるコードを移植して作られています。

## パッケージ構造

複数の executable を生成するパッケージです。
それぞれが独立したウェブページで利用されます。
つまり、複数のアプリケーションをまとめてビルドしています。

JavaScriptライブラリについては、ローダとJavaScriptKitのランタイムライブラリをソースコードで配置していて、自前でビルドしています。ローダは [Carton の実装](https://github.com/swiftwasm/carton/tree/main/entrypoint)を元にしています。

## 環境構築

### Swift の準備

Wasm に対応した Swift が必要です。また、 Wasm SDK がインストールされている必要があります。[インストール方法はこちら](../docs/configure.md)を参照してください。

### Node.js 

Node.js が必要です。 Homebrew からインストールしてください。

```sh
$ brew install node
```

JSの依存ライブラリを以下のコマンドでインストールします。

```sh
$ npm install
```

## Swiftのビルド

ビルドコマンドはスクリプトにしています。

```sh
$ bin/build
```

## エントリポイントの生成

エントリポイントは `Package.swift` の中身に基づいて自動生成しています。
executable を追加した時は以下を実行して再生成する必要があります。

```sh
$ bin/gen-pages
```

## JSのビルドとホスト

以下のコマンドで、JavaScriptのビルドとコンテンツのホストが実行されます。

```sh
$ npm run dev
```

アクセスURLがそのままコンソールに表示されるので、ブラウザで開いてください。
