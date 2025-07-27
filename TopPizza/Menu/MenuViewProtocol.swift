import UIKit

protocol MenuViewProtocol: AnyObject {
    func reloadData()
    func showBanner(message: String, textColor: UIColor, iconName: String)
    func scrollToSection(index: Int)
    func showMeals(_ meals: [Meal])
}

protocol MenuPresenterProtocol: AnyObject {
    var numberOfSections: Int { get }
    func viewDidLoad()
    func numberOfItems(in section: Int) -> Int
    func item(at indexPath: IndexPath) -> MenuItem
    func title(for section: Int) -> String
    func didTapCategory(at index: Int)
}
