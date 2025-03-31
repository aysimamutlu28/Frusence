import Foundation

struct Recipe: Identifiable {
    let id: UUID
    let name: String
    let description: String
    let ingredients: [String]
    let type: RecipeType
    var isLiked: Bool
    var isExpanded: Bool
    
    init(id: UUID = UUID(), name: String, description: String, ingredients: [String], type: RecipeType, isLiked: Bool, isExpanded: Bool) {
        self.id = id
        self.name = name
        self.description = description
        self.ingredients = ingredients
        self.type = type
        self.isLiked = isLiked
        self.isExpanded = isExpanded
    }
    
    static func generateDescription(ingredients: [String], type: RecipeType, hasIce: Bool, hasYogurt: Bool, hasCereals: Bool, hasSeeds: Bool) -> String {
        var steps: [String] = []
        let mainIngredients = ingredients.joined(separator: ", ")
        
        switch type {
        case .smoothie:
            steps.append("- Wash and cut the fruits: \(mainIngredients)")
            if hasIce { steps.append("- Add ice cubes for extra freshness") }
            if hasYogurt { steps.append("- Pour in some yogurt for creaminess") }
            if hasCereals { steps.append("- Add your favorite cereals for texture") }
            if hasSeeds { steps.append("- Sprinkle some seeds for extra nutrients") }
            steps.append("- Blend everything until smooth")
            steps.append("-  Pour into a glass and enjoy!")
            
        case .fruitSalad:
            steps.append("- Wash and cut into bite-sized pieces: \(mainIngredients)")
            if hasYogurt { steps.append("- Add a dollop of yogurt") }
            if hasCereals { steps.append("- Sprinkle with granola") }
            if hasSeeds { steps.append("- Top with mixed seeds") }
            steps.append("- Gently mix everything")
            steps.append("- Chill for 10 minutes before serving")
            
        case .fruitBowl:
            steps.append("- Prepare the fruits: \(mainIngredients)")
            if hasYogurt { steps.append("- Create a yogurt base in the bowl") }
            steps.append("- Arrange fruits in a decorative pattern")
            if hasCereals { steps.append("- Add a layer of crunchy cereals") }
            if hasSeeds { steps.append("- Garnish with seeds") }
            steps.append("- Serve immediately while fresh")
            
        case .detoxWater:
            steps.append("- Slice thinly: \(mainIngredients)")
            steps.append("- Fill a large pitcher with fresh water")
            if hasIce { steps.append("- Add ice cubes") }
            steps.append("- Add the sliced fruits")
            steps.append("- Let it infuse for 2-3 hours")
            steps.append("- Strain and serve chilled")
            
        case .popsicle:
            steps.append("- Blend together: \(mainIngredients)")
            if hasYogurt { steps.append("- Mix with yogurt for creaminess") }
            if hasSeeds { steps.append("- Add some seeds for crunch") }
            steps.append("- Pour into popsicle molds")
            steps.append("- Freeze for at least 4 hours")
            steps.append("- Enjoy your healthy frozen treat!")
            
        case .energyBalls:
            steps.append("- Finely chop: \(mainIngredients)")
            if hasCereals { steps.append("- Mix with crushed cereals") }
            if hasSeeds { steps.append("- Add seeds for protein boost") }
            steps.append("- Form into small balls")
            steps.append("- Roll in coconut or cocoa powder")
            steps.append("- Refrigerate for 30 minutes")
        }
        
        return steps.joined(separator: "\n")
    }
    
    static func generateName(ingredients: [String], type: RecipeType) -> String {
        let mainIngredient = ingredients.first ?? "Fruit"
        
        switch type {
        case .smoothie:
            let adjectives = ["Energizing", "Refreshing", "Tropical", "Power", "Morning"]
            return "\(adjectives.randomElement() ?? "") \(mainIngredient) Smoothie"
            
        case .fruitSalad:
            let adjectives = ["Fresh", "Vibrant", "Summer", "Rainbow", "Vitamin"]
            return "\(adjectives.randomElement() ?? "") Fruit Salad"
            
        case .fruitBowl:
            let adjectives = ["Nourishing", "Sunshine", "Tropical", "Paradise"]
            return "\(adjectives.randomElement() ?? "") \(mainIngredient) Bowl"
            
        case .detoxWater:
            let adjectives = ["Refreshing", "Cleansing", "Spa", "Citrus"]
            return "\(adjectives.randomElement() ?? "") Infused Water"
            
        case .popsicle:
            let adjectives = ["Frozen", "Summer", "Fresh", "Cool"]
            return "\(adjectives.randomElement() ?? "") \(mainIngredient) Pops"
            
        case .energyBalls:
            let adjectives = ["Energy", "Power", "Protein", "Healthy"]
            return "\(adjectives.randomElement() ?? "") Fruit Balls"
        }
    }
}

enum RecipeType: String {
    case smoothie
    case fruitSalad
    case fruitBowl
    case detoxWater
    case popsicle
    case energyBalls
    
    var title: String {
        switch self {
        case .smoothie: return "Smoothie"
        case .fruitSalad: return "Fruit Salad"
        case .fruitBowl: return "Fruit Bowl"
        case .detoxWater: return "Detox Water"
        case .popsicle: return "Popsicle"
        case .energyBalls: return "Energy Balls"
        }
    }
    
    static func availableTypes(fruitsCount: Int, hasYogurt: Bool, hasIce: Bool) -> [RecipeType] {
        var types: [RecipeType] = []
        
        if fruitsCount >= 2 {
            types.append(.smoothie)
            types.append(.fruitBowl)
            types.append(.detoxWater)
        }
        
        if fruitsCount >= 3 {
            types.append(.fruitSalad)
            types.append(.popsicle)
        }
        
        if fruitsCount >= 2 && hasYogurt {
            types.append(.energyBalls)
        }
        
        return types.shuffled()
    }
} 
