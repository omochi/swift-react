# Testing

This project includes two types of tests:

- [Tests](../Tests): Automatic tests conducted with Swift CLI.

- [BrowserTests](../BrowserTests): Manual tests conducted in a browser.

Here's a description of each type:

## Automatic Tests

These tests have two execution modes for operating the DOM system under React:

### Browser Execution Mode via Carton

Using Carton's testing features, test code compiled into Wasm is connected with the real DOM for testing in a browser. Carton is used solely for its testing capabilities, with the build to Wasm being configured independently. Therefore, preparing the environment is necessary for building: [Setting Up Environment](./configure.md)

Build and test execution are wrapped in a script, so you use the following command:

```sh
$ bin/test
```

### Host Execution Mode via Swift CLI

In this mode, tests connect to a mock library that emulates the DOM.

To enable the mock, please edit Package.swift as follows:

```swift
let usesJavaScriptKitMockOnMac = true
```

After that, just like a normal Swift package, you execute tests on the host machine with the following command:

```sh
$ swift test
```

In this mode, tests connect to a mock library that emulates the DOM. The mock consists of the following modules:

- [JavaScriptKitMock](../Sources/JavaScriptKitMock): This is a mock library that is source-compatible with JavaScriptKit. Rather than connecting to actual JavaScript, it interfaces with objects implemented in Swift.

- [WebMock](../Sources/WebMock): A mock implementation that performs some of the same functionalities as the DOM API. It complies with the interface of JavaScriptKitMock and can be operated through it.

## Manual Tests Conducted in a Browser

[BrowserTests](../BrowserTests) is a project for manually testing Swift React in a browser. Please refer to the linked document for details on how to execute the tests.
