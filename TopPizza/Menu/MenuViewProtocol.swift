import Foundation

protocol MenuViewProtocol: AnyObject {
    func reloadData()
    func scrollToSection(index: Int)
}

protocol MenuPresenterProtocol: AnyObject {
    var numberOfSections: Int { get }
    func viewDidLoad()
    func numberOfItems(in section: Int) -> Int
    func item(at indexPath: IndexPath) -> MenuItem
    func title(for section: Int) -> String
    func didTapCategory(at index: Int)
}
