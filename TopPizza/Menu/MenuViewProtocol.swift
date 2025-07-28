import UIKit

protocol MenuViewProtocol: AnyObject {
    func reloadData()
    func showBanner(message: String, textColor: UIColor, iconName: String)
    func scrollToSection(index: Int)
    func showMeals(_ meals: [Meal])
}
