protocol AuthPresenterProtocol {
    func loginTapped(username: String?, password: String?)
    func validateInputs(username: String?, password: String?)
}
