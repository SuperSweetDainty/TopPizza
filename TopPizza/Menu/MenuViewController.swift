import UIKit

final class MenuViewController: UIViewController {

    @IBOutlet private weak var cityLabel: UILabel!
    @IBOutlet private weak var arrowImageView: UIImageView!

    private let scrollView = UIScrollView()
    private let contentStackView = UIStackView()
    private var promoScrollView: UIView?
    private let promoStackView = UIStackView()
    private var presenter: MenuPresenter!
    private var meals: [Meal] = []
    private var categoriesScrollView: UIView?
    private var sectionViews: [UIView] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        presenter = MenuPresenter(view: self)
        presenter.viewDidLoad()
        setupScrollView()
        setupContent()
        cityLabel.isHidden = true
        showBanner(message: "Вход выполнен успешно", textColor: UIColor(named: "BannerGreen") ?? .systemGreen, iconName: "CheckCircle")
        DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
            self.cityLabel.isHidden = false
        }
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
            scrollView.topAnchor.constraint(equalTo: cityLabel.bottomAnchor, constant: 16),
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
    }

    private func setupContent() {
        setupPromoBannersSection()

        let categoriesView = createCategories()
        categoriesScrollView = categoriesView
        contentStackView.addArrangedSubview(categoriesView)
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

        let categories = ["Пицца", "Говядина", "Курица", "Десерт"]

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
                self?.presenter.didTapCategory(at: index)
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
            scroll.heightAnchor.constraint(equalToConstant: 40)
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

        for section in 0..<presenter.numberOfSections {
            var items: [MenuItem] = []
            for row in 0..<presenter.numberOfItems(in: section) {
                items.append(presenter.item(at: IndexPath(row: row, section: section)))
            }

            let stack = createItemsStack(from: items)
            contentStackView.addArrangedSubview(stack)
            sectionViews.append(stack)
        }
    }


    func scrollToSection(index: Int) {
        guard index >= 0, index < sectionViews.count else { return }

        let sectionView = sectionViews[index]
        let targetRect = scrollView.convert(sectionView.frame, from: contentStackView)
        scrollView.scrollRectToVisible(targetRect, animated: true)
    }

    func showError(message: String) {
        showBanner(message: message, textColor: .systemRed, iconName: "CloseCircle")
    }
    
    func showMeals(_ meals: [Meal]) {
        self.meals = meals

        for view in contentStackView.arrangedSubviews {
            if view != promoScrollView && view != categoriesScrollView {
                contentStackView.removeArrangedSubview(view)
                view.removeFromSuperview()
            }
        }

        let mockPizzas = [
            MenuItem(name: "Ветчина и грибы ", price: "от 345 р", imageName: "MockPizza", description: "Ветчина,шампиньоны, увеличинная порция моцареллы, томатный соус"),
            MenuItem(name: "Баварские колбаски", price: "от 345 р", imageName: "MockPizza2", description: "Баварски колбаски,ветчина, пикантная пепперони, острая чоризо, моцарелла, томатный соус"),
            MenuItem(name: "Нежный лосось", price: "от 345 р", imageName: "MockPizza3", description: "Лосось, томаты черри, моцарелла, соус песто"),
            MenuItem(name: "Четыре сыра", price: "от 345 р", imageName: "MockPizza4", description: "Соус Карбонара, Сыр Моцарелла, Сыр Пармезан, Сыр Роккфорти, Сыр Чеддер (тёртый)")
        ]

        let mockStack = createItemsStack(from: mockPizzas)
        contentStackView.addArrangedSubview(mockStack)

        setupPizzaListView(with: meals)
    }

    private func setupPizzaListView(with meals: [Meal]) {
        let mealsByCategory = Dictionary(grouping: meals) { $0.strCategory ?? "Без категории" }

        for (_, meals) in mealsByCategory.sorted(by: { $0.key < $1.key }) {
            let items = meals.map {
                MenuItem(
                    name: $0.strMeal,
                    price: "от 400 р",
                    imageName: $0.strMealThumb,
                    description: $0.strInstructions ?? "Без описания"
                )
            }

            let stack = createItemsStack(from: items)
            contentStackView.addArrangedSubview(stack)
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

            // Оборачиваем itemView во вью с фоном и скруглениями
            let container = UIView()
            container.backgroundColor = .white
            container.layer.masksToBounds = true
            container.translatesAutoresizingMaskIntoConstraints = false
            container.addSubview(itemView)

            // Скругления только у первой и последней карточки
            var corners: CACornerMask = []
            if isFirst { corners.formUnion([.layerMinXMinYCorner, .layerMaxXMinYCorner]) }
            if isLast  { corners.formUnion([.layerMinXMaxYCorner, .layerMaxXMaxYCorner]) }

            container.layer.cornerRadius = 20
            container.layer.maskedCorners = corners

            // Constraints для itemView внутри container
            itemView.translatesAutoresizingMaskIntoConstraints = false
            NSLayoutConstraint.activate([
                itemView.topAnchor.constraint(equalTo: container.topAnchor),
                itemView.bottomAnchor.constraint(equalTo: container.bottomAnchor),
                itemView.leadingAnchor.constraint(equalTo: container.leadingAnchor),
                itemView.trailingAnchor.constraint(equalTo: container.trailingAnchor)
            ])

            stack.addArrangedSubview(container)

            // Добавляем 1pt разделитель после каждого, кроме последнего
            if !isLast {
                let separator = UIView()
                separator.backgroundColor = UIColor.systemGray5
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
