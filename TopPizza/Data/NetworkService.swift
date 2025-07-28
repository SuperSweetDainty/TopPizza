import Foundation

protocol NetworkServiceProtocol {
    func fetchMeals(onResult: @escaping (Result<[Meal], Error>) -> Void)
}

final class NetworkService: NetworkServiceProtocol {
    private let apiService: MealAPIService
    private let baseURL = "https://themealdb.com/api/json/v1/1/search.php?s="
    
    init(apiService: MealAPIService = MealAPIService()) {
        self.apiService = apiService
    }

    func fetchMeals(onResult completion: @escaping (Result<[Meal], Error>) -> Void) {
        apiService.fetchMeals(completion: completion)
    }
}

enum NetworkError: Error {
    case invalidURL
    case noData
}
