import Foundation

final class MealAPIService {
    private let urlString = "https://www.themealdb.com/api/json/v1/1/search.php?s="

    func fetchMeals(completion: @escaping (Result<[Meal], Error>) -> Void) {
        guard let url = URL(string: urlString) else {
            completion(.failure(NSError(domain: "InvalidURL", code: -1)))
            return
        }

        let task = URLSession.shared.dataTask(with: url) { data, _, error in
            if let error = error {
                completion(.failure(error))
                return
            }

            guard let data = data else {
                completion(.failure(NSError(domain: "NoData", code: -2)))
                return
            }

            do {
                let response = try JSONDecoder().decode(MealResponse.self, from: data)
                completion(.success(response.meals))
            } catch {
                completion(.failure(error))
            }
        }

        task.resume()
    }
}
