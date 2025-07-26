import UIKit

final class MenuViewController: UIViewController {

    @IBOutlet private weak var cityLabel: UILabel!
    @IBOutlet private weak var arrowImageView: UIImageView!

    private let scrollView = UIScrollView()
    private let contentStackView = UIStackView()
    private let promoScrollView = UIScrollView()
    private let promoStackView = UIStackView()

    override func viewDidLoad() {
        super.viewDidLoad()
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

            bannersStack.heightAnchor.constraint(equalTo: scrollView.frameLayoutGuide.heightAnchor)
        ])

        // ✅ Оборачиваем в контейнер для вставки в contentStackView
        let container = UIView()
        container.addSubview(scrollView)

        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: container.topAnchor),
            scrollView.leadingAnchor.constraint(equalTo: container.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: container.trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: container.bottomAnchor),
            scrollView.heightAnchor.constraint(equalToConstant: 112)
        ])

        // ✅ Добавляем контейнер в contentStackView
        contentStackView.addArrangedSubview(container)
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
        let categories = createCategories()
        let menu = createPizzaList()

        setupPromoBannersSection()
        contentStackView.addArrangedSubview(categories)
        contentStackView.addArrangedSubview(menu)    }
    
    private func createCategories() -> UIView {
        let scroll = UIScrollView()
        scroll.showsHorizontalScrollIndicator = false
        scroll.translatesAutoresizingMaskIntoConstraints = false

        let stack = UIStackView()
        stack.axis = .horizontal
        stack.spacing = 8
        stack.alignment = .center
        stack.translatesAutoresizingMaskIntoConstraints = false

        let categories = ["Пицца", "Комбо", "Десерты", "Напитки"]

        for title in categories {
            let button = UIButton(type: .system)
            button.setTitle(title, for: .normal)
            button.setTitleColor(UIColor(named: "BannerRed") ?? .white, for: .normal)
            button.titleLabel?.font = UIFont.systemFont(ofSize: 13, weight: .bold)
            button.backgroundColor = UIColor(named: "CategoriesPink") ?? .systemPink.withAlphaComponent(0.2)
            button.layer.cornerRadius = 20
            button.translatesAutoresizingMaskIntoConstraints = false

            // Размеры и центрирование
            NSLayoutConstraint.activate([
                button.widthAnchor.constraint(equalToConstant: 88),
                button.heightAnchor.constraint(equalToConstant: 40)
            ])
            button.titleLabel?.textAlignment = .center
            button.contentHorizontalAlignment = .center
            button.contentVerticalAlignment = .center

            stack.addArrangedSubview(button)
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

        return container
    }

    private func createPizzaList() -> UIView {
        let stack = UIStackView()
        stack.axis = .vertical
        stack.spacing = 24

        let pizzas = ["Ветчина и грибы", "Баварские колбаски", "Нежный лосось"]
        pizzas.forEach { name in
            let pizzaView = createPizzaItem(title: name, description: "Описание пиццы", price: "от 345 р")
            stack.addArrangedSubview(pizzaView)
        }

        return stack
    }

    private func createPizzaItem(title: String, description: String, price: String) -> UIView {
        let container = UIView()
        let image = UIImageView(image: UIImage(named: "MockPizza"))
        image.translatesAutoresizingMaskIntoConstraints = false
        image.widthAnchor.constraint(equalToConstant: 132).isActive = true
        image.heightAnchor.constraint(equalToConstant: 132).isActive = true
        image.clipsToBounds = true
        image.contentMode = .scaleAspectFill

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

        let hStack = UIStackView(arrangedSubviews: [image, rightStack])
        hStack.axis = .horizontal
        hStack.spacing = 16
        hStack.alignment = .center
        hStack.translatesAutoresizingMaskIntoConstraints = false

        container.addSubview(hStack)

        NSLayoutConstraint.activate([
            hStack.topAnchor.constraint(equalTo: container.topAnchor),
            hStack.leadingAnchor.constraint(equalTo: container.leadingAnchor, constant: 16),
            hStack.trailingAnchor.constraint(equalTo: container.trailingAnchor, constant: -16),
            hStack.bottomAnchor.constraint(equalTo: container.bottomAnchor)
        ])

        return container
    }
}
