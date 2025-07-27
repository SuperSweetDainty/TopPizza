import Foundation

protocol NetworkServiceProtocol {
    func fetchMeals(completion: @escaping (Result<[Meal], Error>) -> Void)
}

final class NetworkService: NetworkServiceProtocol {
    private let apiService: MealAPIService
    private let baseURL = "https://themealdb.com/api/json/v1/1/search.php?s="
    
    init(apiService: MealAPIService = MealAPIService()) {
        self.apiService = apiService
    }

    func fetchMeals(completion: @escaping (Result<[Meal], Error>) -> Void) {
        apiService.fetchMeals(completion: completion)
    }
}

enum NetworkError: Error {
    case invalidURL
    case noData
}
