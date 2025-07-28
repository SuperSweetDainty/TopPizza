import Foundation

final class MenuPresenter: MenuPresenterProtocol {
    private weak var view: MenuViewProtocol?
    private let networkService: NetworkServiceProtocol
    private var categories: [MenuCategory] = []

    init(view: MenuViewProtocol, networkService: NetworkServiceProtocol = NetworkService()) {
           self.view = view
           self.networkService = networkService
       }

    func viewDidLoad() {
        fetchMeals()
        loadStaticPizzaCategory()
        view?.reloadData()
    }

    func fetchMeals() {
        networkService.fetchMeals { [weak self] result in
            DispatchQueue.main.async {
                switch result {
                case .success(let meals):
                    self?.view?.showMeals(meals)
                case .failure(let error):
                    self?.view?.showBanner(
                        message: "Ошибка загрузки: \(error.localizedDescription)",
                        textColor: .red,
                        iconName: "CloseCircle"
                    )
                }
            }
        }
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
    
    private func loadStaticPizzaCategory() {
        let pizzaItems = [
            MenuItem(name: "Ветчина и грибы ", price: "от 345 р", imageName: "MockPizza", description: "Ветчина,шампиньоны, увеличинная порция моцареллы, томатный соус"),
            MenuItem(name: "Баварские колбаски", price: "от 345 р", imageName: "MockPizza2", description: "Баварски колбаски,ветчина, пикантная пепперони, острая чоризо, моцарелла, томатный соус"),
            MenuItem(name: "Нежный лосось", price: "от 345 р", imageName: "MockPizza3", description: "Лосось, томаты черри, моцарелла, соус песто"),
            MenuItem(name: "Четыре сыра", price: "от 345 р", imageName: "MockPizza4", description: "Соус Карбонара, Сыр Моцарелла, Сыр Пармезан, Сыр Роккфорти, Сыр Чеддер (тёртый)")
        ]

        let pizzaCategory = MenuCategory(title: "Пицца", items: pizzaItems)
        categories = [pizzaCategory]
    }
}
