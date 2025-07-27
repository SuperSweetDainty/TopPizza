import Foundation

struct MenuItem {
    let name: String
    let price: String
    let imageName: String
    let description: String
}

struct MenuCategory {
    let title: String
    let items: [MenuItem]
}
