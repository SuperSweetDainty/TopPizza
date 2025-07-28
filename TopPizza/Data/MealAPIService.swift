import Foundation

final class MealAPIService {
    private let urlString = "https://www.themealdb.com/api/json/v1/1/search.php?s="

    func fetchMeals(completion: @escaping (Result<[Meal], Error>) -> Void) {
        guard let url = URL(string: urlString) else {
            print("Invalid URL: \(urlString)")
            completion(.failure(NSError(domain: "InvalidURL", code: -1)))
            return
        }

        let task = URLSession.shared.dataTask(with: url) { data, response, error in
               if let error {
                   print("URLSession error: \(error.localizedDescription)")
                   completion(.failure(error))
                   return
               }
            
            guard let httpResponse = response as? HTTPURLResponse else {
                        print("❗️ Response is not HTTPURLResponse")
                        completion(.failure(NSError(domain: "InvalidResponse", code: -3)))
                        return
                    }
            
            print("HTTP Status Code: \(httpResponse.statusCode)")

            guard let data = data else {
                        print("No data received")
                        completion(.failure(NSError(domain: "NoData", code: -2)))
                        return
                    }
            
            if let rawJSON = String(data: data, encoding: .utf8) {
                        print("📦 Raw JSON:\n\(rawJSON)")
                    }

            do {
                        let response = try JSONDecoder().decode(MealResponse.self, from: data)
                        print("✅ Successfully decoded \(response.meals.count) meals")
                        completion(.success(response.meals))
                    } catch let decodingError as DecodingError {
                        print("🛑 Decoding error: \(decodingError.localizedDescription)")

                        switch decodingError {
                        case .dataCorrupted(let context):
                            print("📛 Data corrupted: \(context.debugDescription)")
                        case .keyNotFound(let key, let context):
                            print("🔑 Key '\(key)' not found: \(context.debugDescription)")
                        case .typeMismatch(let type, let context):
                            print("📐 Type '\(type)' mismatch: \(context.debugDescription)")
                        case .valueNotFound(let type, let context):
                            print("📭 Value '\(type)' not found: \(context.debugDescription)")
                        @unknown default:
                            print("❗️ Unknown decoding error")
                        }

                        completion(.failure(decodingError))
                    } catch {
                        print("❌ Unexpected decoding error: \(error)")
                        completion(.failure(error))
                    }
        }

        task.resume()
    }
}
