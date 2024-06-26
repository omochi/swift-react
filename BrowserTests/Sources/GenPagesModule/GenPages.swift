import Foundation

public struct GenPages {
    public init() throws {
        rootDir = URL(fileURLWithPath: ".", isDirectory: true)
        pagesDir = rootDir.appending(component: "pages", directoryHint: .isDirectory)
        pages = try Self.pages(rootDir: rootDir)
    }

    var rootDir: URL
    var pagesDir: URL
    var pages: [String]

    public func run() throws {
        try clearPagesDir()
        for page in pages {
            try generateEntryHTML(page: page)
        }
        try generateViteConfig()
        try generateIndexPage()
    }

    private static func pages(rootDir: URL) throws -> [String] {
        let packageCode = try String(contentsOf: rootDir.appending(components: "Package.swift"))
        let pageRegex = /addPage\(name: "(\w*)"/
        return packageCode.matches(of: pageRegex).map { String($0.output.1) }
    }

    private func clearPagesDir() throws {
        let fm = FileManager.default

        try? fm.removeItem(at: pagesDir)
        try fm.createDirectory(at: pagesDir, withIntermediateDirectories: false)
    }

    private func generateEntryHTML(page: String) throws {
        let html = """
        <!DOCTYPE html>
        <html lang="ja">
        <head>
            <meta charset="utf-8">
            <title>\(page)</title>
            <link rel="stylesheet" type="text/css" href="/Sources/BRTSupport/common.css">
            <script type="module">
                import { load } from "/src/loader/load.ts";
                load("/.build/wasm32-unknown-wasi/debug/\(page).wasm");
            </script>
        </head>
        <body>
        </body>
        </html>
        """

        let file = pagesDir.appending(component: "\(page).html")
        try html.write(to: file, atomically: true, encoding: .utf8)
    }

    private func generateViteConfig() throws {
        var parts: [String] = []

        parts.append("""
        import { resolve } from 'path';
        import { defineConfig } from 'vite';

        export default defineConfig({
          build: {
            rollupOptions: {
              input: {
        """)

        for page in pages {
            parts.append("""
                \(page): resolve(__dirname, "pages/\(page).html"),
        """)
        }

        parts.append("""
              },
            },
          }
        });
        """)

        let code = parts.joined(separator: "\n")
        let file = rootDir.appending(component: "vite.config.js")
        try code.write(to: file, atomically: true, encoding: .utf8)
    }

    private func generateIndexPage() throws {
        var parts: [String] = []

        parts.append("""
        <!DOCTYPE html>
        <html lang="ja">
        <head>
            <meta charset="utf-8">
            <title>index</title>
        </head>
        <body>
            <ul>
        """)

        for page in pages {
            parts.append("""
                <li>
                    <a href="./pages/\(page).html">\(page)</a>
                </li>
        """)
        }

        parts.append("""
            </ul>
        </body>
        </html>
        """)

        let code = parts.joined(separator: "\n")
        let file = rootDir.appending(component: "index.html")
        try code.write(to: file, atomically: true, encoding: .utf8)
    }
}
