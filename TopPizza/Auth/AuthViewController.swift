import UIKit

class AuthViewController: UIViewController, UITextFieldDelegate {

    @IBOutlet weak var enterButtonFrameBottomConstraint: NSLayoutConstraint!
    @IBOutlet weak var enterButton: UIButton!
    @IBOutlet weak var loginTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!

    private var isPasswordVisible = false
    private var eyeButton: UIButton!

    override func viewDidLoad() {
        super.viewDidLoad()

        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)

        setupTextField(textField: loginTextField, placeholder: "Логин")
        setupTextField(textField: passwordTextField, placeholder: "Пароль")
        setupButtonBorder()

        loginTextField.delegate = self
        passwordTextField.delegate = self

        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        view.addGestureRecognizer(tapGesture)

        enterButton.alpha = 0.4

        // Изначально скрываем кнопку
        passwordTextField.rightViewMode = .never
    }

    deinit {
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: nil)
    }

    @objc func keyboardWillShow(notification: NSNotification) {
        guard let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue else {
            return
        }

        enterButtonFrameBottomConstraint.constant = keyboardSize.height - view.safeAreaInsets.bottom
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

    @objc func dismissKeyboard() {
        view.endEditing(true)
    }

    @IBAction func EnterButtonTapped(_ sender: UIButton) {
    }


    func setupTextField(textField: UITextField, placeholder: String) {
        textField.layer.borderColor = (UIColor(named: "Grey") ?? .lightGray).cgColor
        textField.layer.borderWidth = 1
        textField.layer.masksToBounds = true

        let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: 44, height: textField.frame.size.height))
        textField.leftView = paddingView
        textField.leftViewMode = .always

        textField.attributedPlaceholder = NSAttributedString(string: placeholder, attributes: [
            NSAttributedString.Key.foregroundColor: UIColor(named: "Grey") ?? .lightGray
        ])

        textField.autocorrectionType = .no
        textField.autocapitalizationType = .none
        textField.spellCheckingType = .no
        textField.textContentType = .oneTimeCode
        textField.isSecureTextEntry = (textField == passwordTextField)
        setupPasswordVisibilityButton()
    }

    func setupButtonBorder() {
        enterButton.layer.borderWidth = 1
        enterButton.layer.borderColor = (UIColor(named: "ButtonBorderGrey") ?? .gray).cgColor
        enterButton.layer.masksToBounds = true
    }

    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let loginText = loginTextField.text ?? ""
        let passwordText = passwordTextField.text ?? ""

        let isAnyTextFieldFilled = !(loginText.isEmpty && passwordText.isEmpty)

        if isAnyTextFieldFilled {
            UIView.animate(withDuration: 0.2) {
                self.enterButton.alpha = 1.0
            }
        } else {
            UIView.animate(withDuration: 0.2) {
                self.enterButton.alpha = 0.4
            }
        }

        // Отображаем иконку, если что-то введено в поле пароля
        if textField == passwordTextField {
            passwordTextField.rightViewMode = string.isEmpty && range.location == 0 ? .never : .always
        }

        return true
    }

    // MARK: - Password Visibility

    func setupPasswordVisibilityButton() {
        eyeButton = UIButton(type: .custom)
        eyeButton.setImage(UIImage(named: "EyeClose"), for: .normal)
        eyeButton.addTarget(self, action: #selector(togglePasswordVisibility), for: .touchUpInside)

        eyeButton.imageView?.contentMode = .scaleAspectFit
        eyeButton.frame = CGRect(x: 0, y: 0, width: 18, height: 18)

        let containerView = UIView(frame: CGRect(x: 0, y: 0, width: 24, height: 18))
        eyeButton.center = CGPoint(x: containerView.bounds.width - 15/2 - 9, y: containerView.bounds.midY)
        containerView.addSubview(eyeButton)

        passwordTextField.rightView = containerView
    }


    @objc func togglePasswordVisibility() {
        isPasswordVisible.toggle()
        passwordTextField.isSecureTextEntry = !isPasswordVisible

        let imageName = isPasswordVisible ? "EyeOpen" : "EyeClose"
        eyeButton.setImage(UIImage(named: imageName), for: .normal)
    }
}
