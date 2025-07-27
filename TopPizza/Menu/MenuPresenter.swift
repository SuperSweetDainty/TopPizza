import Foundation

final class MenuPresenter: MenuPresenterProtocol {
    private weak var view: MenuViewProtocol?
    private var categories: [MenuCategory] = []

    init(view: MenuViewProtocol) {
        self.view = view
    }

    func viewDidLoad() {
        loadMockData()
        view?.reloadData()
    }

    func loadMockData() {
        categories = [
            MenuCategory(title: "Пицца", items: [
                MenuItem(name: "Маргарита", price: "8.99", imageName: "pizza1"),
                MenuItem(name: "Пепперони", price: "9.99", imageName: "pizza2")
            ]),
            MenuCategory(title: "Напитки", items: [
                MenuItem(name: "Кола", price: "1.99", imageName: "cola"),
                MenuItem(name: "Фанта", price: "1.99", imageName: "fanta")
            ])
        ]
    }

    var numberOfSections: Int {
        categories.count
    }

    func numberOfItems(in section: Int) -> Int {
        categories[section].items.count
    }

    func item(at indexPath: IndexPath) -> MenuItem {
        categories[indexPath.section].items[indexPath.row]
    }

    func title(for section: Int) -> String {
        categories[section].title
    }

    func didTapCategory(at index: Int) {
        view?.scrollToSection(index: index)
    }
}
