import Foundation
import Combine
import SwiftUI

class IngredientsViewModel: ObservableObject {
    @Published var ingredients: [Ingredient] = []
    @Published var recipes: [Recipe] = []
    @Published var newIngredientName: String = ""
    @Published var showNewFruitAlert: Bool = false
    @Published var lastDetectedFruit: String = ""
    @Published var isProcessing: Bool = false
    @Published var showMixAnimation = false
    @Published var showRecipes = false
    private var capturedFruits: Set<String> = []
    private var cancellables = Set<AnyCancellable>()
    
    // Settings from onboarding
    private let onboardingSettings: OnboardingFormViewModel
    
    init(onboardingSettings: OnboardingFormViewModel) {
        self.onboardingSettings = onboardingSettings
        
        // Initialize empty ingredients array
        ingredients = []
        
        // Load saved recipes from CoreData
        let savedRecipes = CoreDataManager.shared.fetchSavedRecipes()
        
        // Create basic recipes if there are no saved ones
        if savedRecipes.isEmpty {
            recipes = [
                Recipe(
                    name: "Fruit salad",
                    description: Recipe.generateDescription(
                        ingredients: ["Fruit 1", "Fruit 2", "Fruit 3"],
                        type: .fruitSalad,
                        hasIce: false,
                        hasYogurt: true,
                        hasCereals: true,
                        hasSeeds: false
                    ),
                    ingredients: ["Fruit 1", "Fruit 2", "Fruit 3"],
                    type: .fruitSalad,
                    isLiked: false,
                    isExpanded: false
                ),
                Recipe(
                    name: "Smoothie",
                    description: Recipe.generateDescription(
                        ingredients: ["Fruit 1", "Fruit 2"],
                        type: .smoothie,
                        hasIce: true,
                        hasYogurt: false,
                        hasCereals: false,
                        hasSeeds: true
                    ),
                    ingredients: ["Fruit 1", "Fruit 2"],
                    type: .smoothie,
                    isLiked: false,
                    isExpanded: false
                )
            ]
        } else {
            // Use saved recipes
            recipes = savedRecipes
            
            // Update isLiked state for saved recipes
            for (index, recipe) in recipes.enumerated() {
                recipes[index].isLiked = true
            }
        }
        
        // Subscribe to new fruit notifications
        FruitDetectionService.shared.subscribeFruitDetection(
            self,
            selector: #selector(handleNewFruitDetected(_:))
        )
    }
    
    deinit {
        // Unsubscribe from notifications
        FruitDetectionService.shared.unsubscribeFruitDetection(self)
    }
    
    @objc private func handleNewFruitDetected(_ notification: Notification) {
        guard let fruitName = notification.userInfo?["fruitName"] as? String else { return }
        
        DispatchQueue.main.async {
            self.isProcessing = true
        }
        
        // Simulate asynchronous recognition processing (delay can be adjusted according to actual neural network speed)
        DispatchQueue.global().asyncAfter(deadline: .now() + 1.0) { [weak self] in
            guard let self = self else { return }
            
            DispatchQueue.main.async {
                let newIngredient = Ingredient(name: fruitName)
                if !self.ingredients.contains(where: { $0.name == fruitName }) {
                    withAnimation {
                        self.ingredients.append(newIngredient)
                    }
                }
                self.isProcessing = false
            }
        }
    }
    
    func addAllDetectedFruits() {
        for fruitName in capturedFruits {
            let newIngredient = Ingredient(name: fruitName)
            if !ingredients.contains(where: { $0.name == fruitName }) {
                ingredients.append(newIngredient)
            }
        }
        capturedFruits.removeAll()
    }
    
    func addNewIngredient() {
        let newIngredient = Ingredient(name: "New fruit")
        ingredients.append(newIngredient)
    }
    
    func updateIngredient(_ ingredient: Ingredient, newName: String) {
        if let index = ingredients.firstIndex(where: { $0.id == ingredient.id }) {
            ingredients[index].name = newName
        }
    }
    
    func removeIngredient(_ ingredient: Ingredient) {
        ingredients.removeAll(where: { $0.id == ingredient.id })
    }
    
    func mixIngredients() {
        showMixAnimation = true
        
        // Generate recipes
        generateRecipes()
        
        // After 4 seconds hide animation and show recipes
        DispatchQueue.main.asyncAfter(deadline: .now() + 4) { [weak self] in
            guard let self = self else { return }
            withAnimation(.easeInOut(duration: 0.5)) {
                self.showMixAnimation = false
                self.showRecipes = true
            }
        }
    }
    
    private func generateRecipes() {
        let fruitNames = ingredients.map { $0.name }
        var newRecipes: [Recipe] = []
        
        // Get available recipe types based on fruit count and settings
        let availableTypes = RecipeType.availableTypes(
            fruitsCount: fruitNames.count,
            hasYogurt: onboardingSettings.wantsYogurt ?? false,
            hasIce: onboardingSettings.wantsIce ?? false
        )
        
        // Function to get random fruits
        func getRandomFruits() -> [String] {
            let maxFruits = onboardingSettings.maxFruitsSelected ?? 3
            return Array(fruitNames.shuffled().prefix(maxFruits))
        }
        
        // Generate recipes for each available type
        for type in availableTypes {
            let recipeFruits = getRandomFruits()
            newRecipes.append(Recipe(
                name: Recipe.generateName(ingredients: recipeFruits, type: type),
                description: Recipe.generateDescription(
                    ingredients: recipeFruits,
                    type: type,
                    hasIce: onboardingSettings.wantsIce ?? false,
                    hasYogurt: onboardingSettings.wantsYogurt ?? false,
                    hasCereals: onboardingSettings.wantsCereals ?? false,
                    hasSeeds: onboardingSettings.wantsSeeds ?? false
                ),
                ingredients: recipeFruits,
                type: type,
                isLiked: false,
                isExpanded: false
            ))
        }
        
        // Update recipe list
        recipes = newRecipes
    }
    
    func resetState() {
        showMixAnimation = false
        showRecipes = false
        isProcessing = false
    }
    
    func toggleRecipeLike(_ recipe: Recipe) {
        if let index = recipes.firstIndex(where: { $0.id == recipe.id }) {
            recipes[index].isLiked.toggle()
            
            // Save or delete from CoreData
            if recipes[index].isLiked {
                CoreDataManager.shared.saveRecipe(recipes[index])
            } else {
                CoreDataManager.shared.deleteRecipe(recipes[index])
            }
        }
    }
    
    func toggleRecipeExpansion(_ recipe: Recipe) {
        if let index = recipes.firstIndex(where: { $0.id == recipe.id }) {
            recipes[index].isExpanded.toggle()
            
            // Update state in CoreData if recipe is saved
            if recipes[index].isLiked {
                CoreDataManager.shared.updateRecipeExpansion(recipes[index])
            }
        }
    }
} 
