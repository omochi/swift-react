# Swift React

**Swift React** is a library that implements [React](https://react.dev) from scratch in Swift. Use this to implement interactive websites in Swift.

[日本語はこちらです。](./README.ja.md)

## Overview

**Swift React** aims to be used in the same way as React. However, the API is designed to be Swifty. Below is an example implementation that displays "Hello world."

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

### Target Environments

Targeted for Swift for WASM. Other Swift environments are not supported.

Targeted for running in web browsers. Other WASM execution environments are not supported.

## How to Use

Add it as a dependent library from Swift Package.

```swift
.package(url: "https://github.com/omochi/swift-react", from: "0.1.0")
```

It depends on [JavaScriptKit](https://github.com/swiftwasm/JavaScriptKit), so when loading the WASM binary in a web browser, it is necessary to import the JavaScript runtime library of *JavaScriptKit*. For more details, refer to [Setting Up Environment](./docs/configure.md).

## Documentation

- [Setting Up Environment](./docs/configure.md)
- [API Implementation Status](./docs/api.md)

### For Developers

- [Testing](./docs/testing.md)
