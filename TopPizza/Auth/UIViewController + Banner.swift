import UIKit

extension UIViewController {
    func showBanner(message: String, textColor: UIColor, iconName: String) {
        let bannerView = UIView()
        bannerView.backgroundColor = UIColor(white: 1, alpha: 1)
        bannerView.layer.cornerRadius = 20
        bannerView.layer.shadowColor = UIColor.black.cgColor
        bannerView.layer.shadowOpacity = 0.12
        bannerView.layer.shadowOffset = CGSize(width: 0, height: 4)
        bannerView.layer.shadowRadius = 4
        bannerView.layer.masksToBounds = false

        let label = UILabel()
        label.text = message
        label.font = .systemFont(ofSize: 13, weight: .semibold)
        label.textColor = textColor
        label.translatesAutoresizingMaskIntoConstraints = false

        let imageView = UIImageView(image: UIImage(named: iconName))
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFit

        bannerView.translatesAutoresizingMaskIntoConstraints = false
        bannerView.addSubview(label)
        bannerView.addSubview(imageView)

        self.view.addSubview(bannerView)

        NSLayoutConstraint.activate([
            bannerView.topAnchor.constraint(equalTo: view.topAnchor, constant: 44),
            bannerView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            bannerView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            bannerView.heightAnchor.constraint(equalToConstant: 50),

            label.centerYAnchor.constraint(equalTo: bannerView.centerYAnchor),
            label.centerXAnchor.constraint(equalTo: bannerView.centerXAnchor),

            imageView.widthAnchor.constraint(equalToConstant: 18),
            imageView.heightAnchor.constraint(equalToConstant: 18),
            imageView.trailingAnchor.constraint(equalTo: bannerView.trailingAnchor, constant: -16),
            imageView.topAnchor.constraint(equalTo: bannerView.topAnchor, constant: 16),
        ])

        DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
            bannerView.removeFromSuperview()
        }
    }
}
