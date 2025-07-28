import UIKit

class AuthViewController: UIViewController, UITextFieldDelegate, AuthViewProtocol {
    
    @IBOutlet weak var enterButtonFrameBottomConstraint: NSLayoutConstraint!
    @IBOutlet weak var enterButton: UIButton!
    @IBOutlet weak var loginTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    
    private var presenter: AuthPresenterProtocol!
    private var isPasswordVisible = false
    private var eyeButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        presenter = AuthPresenter(view: self)
        setupUI()
        setupKeyboardObservers()
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    private func setupUI() {
        [loginTextField, passwordTextField].forEach {
            setupTextField($0)
            $0?.delegate = self
        }
        
        setupPasswordVisibilityButton()
        setupButtonBorder()
        
        enterButton.alpha = 0.4
        passwordTextField.rightViewMode = .never
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        view.addGestureRecognizer(tapGesture)
    }
    
    private func setupKeyboardObservers() {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    private func setupTextField(_ textField: UITextField?) {
        guard let textField = textField else { return }
        textField.layer.borderColor = UIColor(named: "Grey")?.cgColor ?? UIColor.lightGray.cgColor
        textField.layer.borderWidth = 1
        textField.layer.masksToBounds = true
        
        let padding = UIView(frame: CGRect(x: 0, y: 0, width: 44, height: 0))
        textField.leftView = padding
        textField.leftViewMode = .always
        
        textField.autocorrectionType = .no
        textField.autocapitalizationType = .none
        textField.spellCheckingType = .no
        textField.textContentType = .oneTimeCode
        
        textField.attributedPlaceholder = NSAttributedString(string: textField == loginTextField ? "Логин" : "Пароль", attributes: [
            .foregroundColor: UIColor(named: "Grey") ?? .lightGray
        ])
        
        textField.isSecureTextEntry = textField == passwordTextField
    }
    
    func setupPasswordVisibilityButton() {
        eyeButton = UIButton(type: .custom)
        eyeButton.setImage(UIImage(named: "EyeClose"), for: .normal)
        eyeButton.addTarget(self, action: #selector(togglePasswordVisibility), for: .touchUpInside)

        eyeButton.imageView?.contentMode = .scaleAspectFit
        eyeButton.frame = CGRect(x: 0, y: 0, width: 18, height: 18)

        let containerView = UIView(frame: CGRect(x: 0, y: 0, width: 18 + 15, height: 18))
        eyeButton.center = CGPoint(x: containerView.bounds.width - 24, y: containerView.bounds.midY)
        containerView.addSubview(eyeButton)

        passwordTextField.rightView = containerView
    }

    
    private func setupButtonBorder() {
        enterButton.layer.borderWidth = 1
        enterButton.layer.borderColor = UIColor(named: "ButtonBorderGrey")?.cgColor ?? UIColor.gray.cgColor
        enterButton.layer.masksToBounds = true
    }
    
    @objc func keyboardWillShow(notification: NSNotification) {
        guard let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue else {
            return
        }

        let keyboardHeight = keyboardSize.height
        enterButtonFrameBottomConstraint.constant = keyboardHeight - view.safeAreaInsets.bottom

        UIView.animate(withDuration: 0.3) {
            self.view.layoutIfNeeded()
        }
    }

    @objc func keyboardWillHide(notification: NSNotification) {
        enterButtonFrameBottomConstraint.constant = 0

        UIView.animate(withDuration: 0.3) {
            self.view.layoutIfNeeded()
        }
    }
    
    @objc private func dismissKeyboard() {
        view.endEditing(true)
    }
    
    @objc private func togglePasswordVisibility() {
        isPasswordVisible.toggle()
        passwordTextField.isSecureTextEntry = !isPasswordVisible
        
        let imageName = isPasswordVisible ? "EyeOpen" : "EyeClose"
        eyeButton.setImage(UIImage(named: imageName), for: .normal)
    }
    
    @IBAction func enterButtonTapped(_ sender: UIButton) {
        dismissKeyboard()
        presenter.loginTapped(username: loginTextField.text, password: passwordTextField.text)
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.01) {
            self.presenter.validateInputs(username: self.loginTextField.text, password: self.passwordTextField.text)
            self.passwordTextField.rightViewMode = (self.passwordTextField.text ?? "").isEmpty ? .never : .always
        }
        return true
    }
    
    func showError(message: String) {
           showBanner(message: message, textColor: UIColor(named: "BannerRed") ?? .systemRed, iconName: "CloseCircle")
       }

       func navigateToMainScreen() {
           let storyboard = UIStoryboard(name: "Main", bundle: nil)
           guard let mainTabBarVC = storyboard.instantiateViewController(withIdentifier: "MainTabBarController") as? UITabBarController else {
               print("Не удалось найти MainTabBarController")
               return
           }
           mainTabBarVC.modalPresentationStyle = .fullScreen
           present(mainTabBarVC, animated: true)
       }

       func updateEnterButton(isEnabled: Bool) {
           UIView.animate(withDuration: 0.2) {
               self.enterButton.alpha = isEnabled ? 1.0 : 0.4
           }
       }
   }
