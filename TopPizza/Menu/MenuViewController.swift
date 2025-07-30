import UIKit

final class MenuViewController: UIViewController, UIScrollViewDelegate {

    @IBOutlet private weak var cityLabel: UILabel?
    @IBOutlet private weak var arrowImageView: UIImageView?

    private let scrollView = UIScrollView()
    private let contentStackView = UIStackView()
    private let promoStackView = UIStackView()
    private let stickyContainerView = UIView()
    private let stickyCategoriesContainer = UIView()
    private var stickyCategoriesView: UIView?
    private var categoriesOriginalView: UIView?
    private var promoScrollView: UIView?
    private var presenter: MenuPresenter?
    private var meals: [Meal] = []
    private var categoriesScrollView: UIView?
    private var sectionViews: [UIView] = []
    private var stickyTopConstraint: NSLayoutConstraint?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        presenter = MenuPresenter(view: self)
        presenter?.viewDidLoad()
        setupScrollView()
        setupStickyCategoriesContainer()

        NSLayoutConstraint.activate([
            stickyCategoriesContainer.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            stickyCategoriesContainer.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            stickyCategoriesContainer.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            stickyCategoriesContainer.heightAnchor.constraint(equalToConstant: 50)
        ])

        stickyCategoriesContainer.isHidden = true
        setupContent()
        cityLabel?.isHidden = true
        showBanner(message: "Вход выполнен успешно", textColor: UIColor(named: "BannerGreen") ?? .systemGreen, iconName: "CheckCircle")
        DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
            self.cityLabel?.isHidden = false
        }
        view.bringSubviewToFront(scrollView)
        view.sendSubviewToBack(stickyCategoriesContainer)
    }
    
    private func setupStickyCategories() {
        stickyCategoriesView = createCategories()
        guard let stickyCategoriesView else { return }
        
        stickyCategoriesContainer.addSubview(stickyCategoriesView)
        stickyCategoriesView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            stickyCategoriesView.topAnchor.constraint(equalTo: stickyCategoriesContainer.topAnchor),
            stickyCategoriesView.leadingAnchor.constraint(equalTo: stickyCategoriesContainer.leadingAnchor),
            stickyCategoriesView.trailingAnchor.constraint(equalTo: stickyCategoriesContainer.trailingAnchor),
            stickyCategoriesView.bottomAnchor.constraint(equalTo: stickyCategoriesContainer.bottomAnchor)
        ])
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        guard let categoriesOriginalView = categoriesOriginalView else { return }

        let frameInView = categoriesOriginalView.convert(categoriesOriginalView.bounds, to: view)
        let shouldStick = frameInView.origin.y <= 104

        stickyCategoriesContainer.isHidden = !shouldStick

        if shouldStick {
            view.bringSubviewToFront(stickyCategoriesContainer)
        }
    }

    private func addShadowToStickyContainer() {
        stickyCategoriesContainer.layer.shadowColor = UIColor.black.withAlphaComponent(0.24).cgColor
        stickyCategoriesContainer.layer.shadowOpacity = 1
        stickyCategoriesContainer.layer.shadowOffset = CGSize(width: 0, height: 6)
        stickyCategoriesContainer.layer.shadowRadius = 7
        stickyCategoriesContainer.layer.masksToBounds = false
    }
    
    private func setupPromoBannersSection() {
        let scrollView = UIScrollView()
        scrollView.showsHorizontalScrollIndicator = false
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.alwaysBounceHorizontal = true

        let bannersStack = UIStackView()
        bannersStack.axis = .horizontal
        bannersStack.spacing = 16
        bannersStack.translatesAutoresizingMaskIntoConstraints = false

        let bannerImages = ["MockImageBanner1", "MockImageBanner2"]
        for imageName in bannerImages {
            let imageView = UIImageView(image: UIImage(named: imageName))
            imageView.contentMode = .scaleAspectFill
            imageView.clipsToBounds = true
            imageView.layer.cornerRadius = 10
            imageView.translatesAutoresizingMaskIntoConstraints = false
            NSLayoutConstraint.activate([
                imageView.widthAnchor.constraint(equalToConstant: 300),
                imageView.heightAnchor.constraint(equalToConstant: 112)
            ])
            bannersStack.addArrangedSubview(imageView)
        }

        scrollView.addSubview(bannersStack)

        NSLayoutConstraint.activate([
            bannersStack.topAnchor.constraint(equalTo: scrollView.contentLayoutGuide.topAnchor),
            bannersStack.leadingAnchor.constraint(equalTo: scrollView.contentLayoutGuide.leadingAnchor, constant: 16),
            bannersStack.trailingAnchor.constraint(equalTo: scrollView.contentLayoutGuide.trailingAnchor, constant: -16),
            bannersStack.bottomAnchor.constraint(equalTo: scrollView.contentLayoutGuide.bottomAnchor),
            bannersStack.heightAnchor.constraint(equalToConstant: 112)
        ])

        let container = UIView()
        container.translatesAutoresizingMaskIntoConstraints = false
        container.addSubview(scrollView)

        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: container.topAnchor),
            scrollView.leadingAnchor.constraint(equalTo: container.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: container.trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: container.bottomAnchor),
            scrollView.heightAnchor.constraint(equalToConstant: 112)
        ])

        contentStackView.addArrangedSubview(container)

        self.promoScrollView = container
    }


    private func setupScrollView() {
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(scrollView)

        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: cityLabel?.bottomAnchor ?? view.safeAreaLayoutGuide.topAnchor, constant: 16),
            scrollView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])

        contentStackView.axis = .vertical
        contentStackView.spacing = 16
        contentStackView.translatesAutoresizingMaskIntoConstraints = false

        scrollView.addSubview(contentStackView)

        NSLayoutConstraint.activate([
            contentStackView.topAnchor.constraint(equalTo: scrollView.contentLayoutGuide.topAnchor),
            contentStackView.leadingAnchor.constraint(equalTo: scrollView.contentLayoutGuide.leadingAnchor),
            contentStackView.trailingAnchor.constraint(equalTo: scrollView.contentLayoutGuide.trailingAnchor),
            contentStackView.bottomAnchor.constraint(equalTo: scrollView.contentLayoutGuide.bottomAnchor),
            contentStackView.widthAnchor.constraint(equalTo: scrollView.frameLayoutGuide.widthAnchor)
        ])

        stickyContainerView.translatesAutoresizingMaskIntoConstraints = false
        stickyContainerView.backgroundColor = UIColor(named: "BackgroundColor")
        view.addSubview(stickyContainerView)

        stickyTopConstraint = stickyContainerView.topAnchor.constraint(equalTo: scrollView.topAnchor, constant: 0)
        stickyTopConstraint?.isActive = true

        NSLayoutConstraint.activate([
            stickyContainerView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            stickyContainerView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            stickyContainerView.heightAnchor.constraint(equalToConstant: 40)
        ])

        scrollView.delegate = self
    }

    private func setupContent() {
        setupPromoBannersSection()

        let originalCategories = createCategories()
        categoriesScrollView = originalCategories
        categoriesOriginalView = originalCategories
        contentStackView.addArrangedSubview(originalCategories)
    }

    
    private func applyStickyShadow() {
        stickyContainerView.layer.shadowColor = UIColor(named: "CategoryShadow")?.cgColor
            ?? UIColor.black.withAlphaComponent(0.24).cgColor
        stickyContainerView.layer.shadowOpacity = 1
        stickyContainerView.layer.shadowOffset = CGSize(width: 0, height: 6)
        stickyContainerView.layer.shadowRadius = 14 / 2
        stickyContainerView.layer.masksToBounds = false
    }
    
    private func setupStickyCategoriesContainer() {
        stickyCategoriesContainer.translatesAutoresizingMaskIntoConstraints = false
        stickyCategoriesContainer.backgroundColor = UIColor(named: "BackgroundColor")
        stickyCategoriesContainer.isHidden = true
        view.addSubview(stickyCategoriesContainer)
        view.sendSubviewToBack(stickyCategoriesContainer)

        NSLayoutConstraint.activate([
            stickyCategoriesContainer.topAnchor.constraint(equalTo: view.topAnchor, constant: 104),
            stickyCategoriesContainer.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            stickyCategoriesContainer.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            stickyCategoriesContainer.heightAnchor.constraint(equalToConstant: 50)
        ])
        
        let stickyCategories = createCategories()
        stickyCategoriesView = stickyCategories

        stickyCategoriesContainer.addSubview(stickyCategories)
        stickyCategories.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            stickyCategories.topAnchor.constraint(equalTo: stickyCategoriesContainer.topAnchor),
            stickyCategories.leadingAnchor.constraint(equalTo: stickyCategoriesContainer.leadingAnchor),
            stickyCategories.trailingAnchor.constraint(equalTo: stickyCategoriesContainer.trailingAnchor),
            stickyCategories.bottomAnchor.constraint(equalTo: stickyCategoriesContainer.bottomAnchor)
        ])

        stickyCategoriesContainer.layer.shadowColor = UIColor(named: "CategoryShadow")?.cgColor ?? UIColor.black.withAlphaComponent(0.24).cgColor
        stickyCategoriesContainer.layer.shadowOpacity = 1
        stickyCategoriesContainer.layer.shadowOffset = CGSize(width: 0, height: 6)
        stickyCategoriesContainer.layer.shadowRadius = 7
        stickyCategoriesContainer.layer.masksToBounds = false
    }
    
    private func createCategories() -> UIView {
        let scroll = UIScrollView()
        scroll.showsHorizontalScrollIndicator = false
        scroll.translatesAutoresizingMaskIntoConstraints = false

        let stack = UIStackView()
        stack.axis = .horizontal
        stack.spacing = 8
        stack.alignment = .center
        stack.translatesAutoresizingMaskIntoConstraints = false

        let categories = ["Pizza", "Beef", "Chicken", "Dessert", "Lamb", "Miscellaneous", "Pasta", "Pork", "Seafood", "Side", "Vegetarian"]

        for (index, title) in categories.enumerated() {
            let button = UIButton(type: .system)
            button.setTitle(title, for: .normal)
            button.setTitleColor(UIColor(named: "BannerRed") ?? .white, for: .normal)
            button.titleLabel?.font = UIFont.systemFont(ofSize: 13, weight: .bold)
            button.backgroundColor = UIColor(named: "CategoriesPink") ?? .systemPink.withAlphaComponent(0.2)
            button.layer.cornerRadius = 20
            button.translatesAutoresizingMaskIntoConstraints = false

            NSLayoutConstraint.activate([
                button.widthAnchor.constraint(equalToConstant: 88),
                button.heightAnchor.constraint(equalToConstant: 40)
            ])
            button.titleLabel?.textAlignment = .center
            button.contentHorizontalAlignment = .center
            button.contentVerticalAlignment = .center

            stack.addArrangedSubview(button)
            
            button.addAction(UIAction { [weak self] _ in
                self?.presenter?.didTapCategory(at: index)
            }, for: .touchUpInside)
        }

        scroll.addSubview(stack)

        NSLayoutConstraint.activate([
            stack.topAnchor.constraint(equalTo: scroll.contentLayoutGuide.topAnchor),
            stack.leadingAnchor.constraint(equalTo: scroll.contentLayoutGuide.leadingAnchor, constant: 16),
            stack.trailingAnchor.constraint(equalTo: scroll.contentLayoutGuide.trailingAnchor, constant: -16),
            stack.bottomAnchor.constraint(equalTo: scroll.contentLayoutGuide.bottomAnchor),
            stack.heightAnchor.constraint(equalTo: scroll.frameLayoutGuide.heightAnchor)
        ])

        let container = UIView()
        container.addSubview(scroll)

        NSLayoutConstraint.activate([
            scroll.topAnchor.constraint(equalTo: container.topAnchor),
            scroll.leadingAnchor.constraint(equalTo: container.leadingAnchor),
            scroll.trailingAnchor.constraint(equalTo: container.trailingAnchor),
            scroll.bottomAnchor.constraint(equalTo: container.bottomAnchor),
            scroll.heightAnchor.constraint(equalToConstant: 48)
        ])
        self.categoriesScrollView = container
        return container
    }

    private func createPizzaItem(title: String, description: String, price: String, imageURL: String?) -> UIView {
        let cardView = UIView()
        cardView.translatesAutoresizingMaskIntoConstraints = false
        cardView.backgroundColor = .white
        cardView.layer.cornerRadius = 20
        cardView.layer.masksToBounds = true

        let container = UIView()
        container.translatesAutoresizingMaskIntoConstraints = false

        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.widthAnchor.constraint(equalToConstant: 132).isActive = true
        imageView.heightAnchor.constraint(equalToConstant: 132).isActive = true
        imageView.clipsToBounds = true
        imageView.contentMode = .scaleAspectFill
        imageView.layer.cornerRadius = 10

        if let imageURL = imageURL {
            if let localImage = UIImage(named: imageURL) {
                imageView.image = localImage
            } else if let url = URL(string: imageURL), UIApplication.shared.canOpenURL(url) {
                URLSession.shared.dataTask(with: url) { data, _, _ in
                    if let data = data, let image = UIImage(data: data) {
                        DispatchQueue.main.async {
                            imageView.image = image
                        }
                    }
                }.resume()
            } else {
                imageView.image = UIImage(named: "MockPizza")
            }
        } else {
            imageView.image = UIImage(named: "MockPizza")
        }

        let titleLabel = UILabel()
        titleLabel.text = title
        titleLabel.font = UIFont.systemFont(ofSize: 17, weight: .semibold)

        let descLabel = UILabel()
        descLabel.text = description
        descLabel.font = UIFont.systemFont(ofSize: 13)
        descLabel.numberOfLines = 4
        descLabel.textColor = UIColor(named: "Grey") ?? .gray

        let priceButton = UIButton(type: .system)
        priceButton.setTitle(price, for: .normal)
        priceButton.setTitleColor(UIColor(named: "BannerRed") ?? .systemPink, for: .normal)
        priceButton.layer.cornerRadius = 6
        priceButton.layer.borderWidth = 1
        priceButton.layer.borderColor = (UIColor(named: "BannerRed") ?? .systemPink).cgColor
        priceButton.titleLabel?.font = UIFont.systemFont(ofSize: 13)

        let rightStack = UIStackView(arrangedSubviews: [titleLabel, descLabel, priceButton])
        rightStack.axis = .vertical
        rightStack.spacing = 4

        let hStack = UIStackView(arrangedSubviews: [imageView, rightStack])
        hStack.axis = .horizontal
        hStack.spacing = 16
        hStack.alignment = .center
        hStack.translatesAutoresizingMaskIntoConstraints = false

        container.addSubview(hStack)
        NSLayoutConstraint.activate([
            hStack.topAnchor.constraint(equalTo: container.topAnchor, constant: 16),
            hStack.leadingAnchor.constraint(equalTo: container.leadingAnchor, constant: 16),
            hStack.trailingAnchor.constraint(equalTo: container.trailingAnchor, constant: -16),
            hStack.bottomAnchor.constraint(equalTo: container.bottomAnchor, constant: -16)
        ])

        cardView.addSubview(container)
        NSLayoutConstraint.activate([
            container.topAnchor.constraint(equalTo: cardView.topAnchor),
            container.leadingAnchor.constraint(equalTo: cardView.leadingAnchor),
            container.trailingAnchor.constraint(equalTo: cardView.trailingAnchor),
            container.bottomAnchor.constraint(equalTo: cardView.bottomAnchor)
        ])

        return cardView
    }
}

extension MenuViewController: MenuViewProtocol {
    func reloadData() {
        for view in contentStackView.arrangedSubviews {
            if view != promoScrollView && view != categoriesScrollView {
                contentStackView.removeArrangedSubview(view)
                view.removeFromSuperview()
            }
        }

        sectionViews.removeAll()

        for section in 0..<(presenter?.numberOfSections ?? 0) {
            var items: [MenuItem] = []
            for row in 0..<(presenter?.numberOfItems(in: section) ?? 0) {
                if let item = presenter?.item(at: IndexPath(row: row, section: section)) {
                    items.append(item)
                }
            }

            let stack = createItemsStack(from: items)
            contentStackView.addArrangedSubview(stack)
            sectionViews.append(stack)
        }
    }


    func scrollToSection(index: Int) {
        guard index >= 0, index < sectionViews.count else { return }

        let sectionView = sectionViews[index]
        let sectionFrame = sectionView.convert(sectionView.bounds, to: scrollView)

        let categoryBarHeight = categoriesScrollView?.frame.height ?? 40
        let extraPadding: CGFloat = 0

        let targetOffsetY = sectionFrame.minY - categoryBarHeight - extraPadding
        let adjustedOffset = CGPoint(x: 0, y: max(0, targetOffsetY))

        scrollView.setContentOffset(adjustedOffset, animated: true)
    }
    
    func showMeals(_ meals: [Meal]) {
        self.meals = meals

        for view in contentStackView.arrangedSubviews {
            if view != promoScrollView && view != categoriesScrollView {
                contentStackView.removeArrangedSubview(view)
                view.removeFromSuperview()
            }
        }

        sectionViews.removeAll()

        let mockPizzas = [
            MenuItem(name: "Ham and mushrooms ", price: "from 3$", imageName: "MockPizza", description: "Ham, champignons, extra mozzarella, tomato sauce"),
            MenuItem(name: "Bavarian sausages", price: "from 3$", imageName: "MockPizza2", description: "Bavarian sausages, ham, spicy pepperoni, spicy chorizo, mozzarella, tomato sauce"),
            MenuItem(name: "Tender salmon", price: "from 3$", imageName: "MockPizza3", description: "Salmon, cherry tomatoes, mozzarella, pesto sauce"),
            MenuItem(name: "Four cheeses", price: "from 3$", imageName: "MockPizza4", description: "Carbonara sauce, Mozzarella cheese, Parmesan cheese, Roccaforti cheese, Cheddar cheese (grated)")
        ]

        let mockStack = createItemsStack(from: mockPizzas)
        contentStackView.addArrangedSubview(mockStack)
        sectionViews.append(mockStack)

        setupPizzaListView(with: meals)
    }


    private func setupPizzaListView(with meals: [Meal]) {
        let mealsByCategory = Dictionary(grouping: meals) { $0.strCategory ?? "Uncategorized" }

        for (_, meals) in mealsByCategory.sorted(by: { $0.key < $1.key }) {

            let items = meals.compactMap { meal -> MenuItem? in
                guard
                    let name = meal.strMeal,
                    let image = meal.strMealThumb,
                    !image.isEmpty
                else {
                    return nil
                }

                return MenuItem(
                    name: name,
                    price: "from 2.5$",
                    imageName: image,
                    description: meal.ingredients.joined(separator: ", ")
                )
            }

            guard !items.isEmpty else { continue }

            let stack = createItemsStack(from: items)
            contentStackView.addArrangedSubview(stack)
            sectionViews.append(stack)
        }
    }


    
    private func createItemsStack(from items: [MenuItem]) -> UIStackView {
        let stack = UIStackView()
        stack.axis = .vertical
        stack.spacing = 0

        for (index, item) in items.enumerated() {
            let isFirst = index == 0
            let isLast = index == items.count - 1

            let itemView = createPizzaItem(
                title: item.name,
                description: item.description,
                price: item.price,
                imageURL: item.imageName
            )

            let container = UIView()
            container.backgroundColor = .white
            container.layer.masksToBounds = true
            container.translatesAutoresizingMaskIntoConstraints = false
            container.addSubview(itemView)

            var corners: CACornerMask = []
            if isFirst { corners.formUnion([.layerMinXMinYCorner, .layerMaxXMinYCorner]) }
            if isLast  { corners.formUnion([.layerMinXMaxYCorner, .layerMaxXMaxYCorner]) }

            container.layer.cornerRadius = 20
            container.layer.maskedCorners = corners
            itemView.translatesAutoresizingMaskIntoConstraints = false
            NSLayoutConstraint.activate([
                itemView.topAnchor.constraint(equalTo: container.topAnchor),
                itemView.bottomAnchor.constraint(equalTo: container.bottomAnchor),
                itemView.leadingAnchor.constraint(equalTo: container.leadingAnchor),
                itemView.trailingAnchor.constraint(equalTo: container.trailingAnchor)
            ])

            stack.addArrangedSubview(container)

            if !isLast {
                let separator = UIView()
                separator.backgroundColor = .background
                separator.translatesAutoresizingMaskIntoConstraints = false
                NSLayoutConstraint.activate([
                    separator.heightAnchor.constraint(equalToConstant: 1)
                ])
                stack.addArrangedSubview(separator)
            }
        }

        return stack
    }
}
