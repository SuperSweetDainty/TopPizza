import Foundation

struct MenuItem {
    let name: String
    let price: String
    let imageName: String
}

struct MenuCategory {
    let title: String
    let items: [MenuItem]
}
