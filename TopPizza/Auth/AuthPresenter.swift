import Foundation

class AuthPresenter: AuthPresenterProtocol {
    private weak var view: AuthViewProtocol?
    private let model = AuthModel()

    init(view: AuthViewProtocol) {
        self.view = view
    }

    func loginTapped(username: String?, password: String?) {
        guard
            let login = username, !login.isEmpty,
            let password = password, !password.isEmpty
        else {
            view?.showError(message: "Введите логин и пароль")
            return
        }

        if model.validateCredentials(username: login, password: password) {
            UserDefaults.standard.set(true, forKey: "shouldShowSuccessBanner")
            view?.navigateToMainScreen()
        } else {
            view?.showError(message: "Неверный логин или пароль")
        }
    }

    func validateInputs(username: String?, password: String?) {
        let isValid = !(username?.isEmpty ?? true) || !(password?.isEmpty ?? true)
        view?.updateEnterButton(isEnabled: isValid)
    }
}
