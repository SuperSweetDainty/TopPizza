struct AuthModel {
    let correctLogin = "Qwerty123"
    let correctPassword = "Qwerty123"

    func validateCredentials(username: String, password: String) -> Bool {
        return username == correctLogin && password == correctPassword
    }
}
