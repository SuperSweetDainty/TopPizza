protocol AuthViewProtocol: AnyObject {
    func showError(message: String)
    func navigateToMainScreen()
    func updateEnterButton(isEnabled: Bool)
}
