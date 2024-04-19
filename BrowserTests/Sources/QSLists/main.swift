import React
import JavaScriptKit
import SRTDOM
import BRTSupport

// https://ja.react.dev/learn#rendering-lists

struct Product {
    var title: String
    var isFruit: Bool
    var id: Int

    static let products: [Product] = [
        .init(title: "Cabbage", isFruit: false, id: 1),
        .init(title: "Garlic", isFruit: false, id: 2),
        .init(title: "Apple", isFruit: true, id: 3),
    ]
}

struct ShoppingList: Component {
    var products: [Product] = Product.products

    func render() -> Node {
        let listItems = products.map { (product) in
            li(
                key: product.id,
                attributes: [
                    "style": """
                        color: \(product.isFruit ? "magenta" : "darkgreen");
                    """
                ]
            ) {
                product.title
            }
        }

        return ul {
            listItems
        }
    }
}

try renderRoot(component: ShoppingList())
