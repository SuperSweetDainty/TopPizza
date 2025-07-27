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
//        loadMockData()
        fetchMeals()
//        view?.reloadData()  !!!
    }

    private func fetchMeals() {
        networkService.fetchMeals { [weak self] result in
            DispatchQueue.main.async {
                switch result {
                case .success(let meals):
                    self?.view?.showMeals(meals)
                case .failure(let error):
                    self?.view?.showBanner(
                        message: "Ошибка загрузки: \(error.localizedDescription)",
                        textColor: .red,
                        iconName: "XmarkCircle"
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
}
