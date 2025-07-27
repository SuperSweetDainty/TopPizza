struct MealResponse: Decodable {
    let meals: [Meal]
}

struct Meal: Decodable {
    let idMeal: String
    let strMeal: String
    let strInstructions: String?
    let strMealThumb: String
    let strCategory: String?
}
