import SwiftUI
import Combine

class SavedRecipesViewModel: ObservableObject {
    @Published var savedRecipes: [Recipe] = []
    private var cancellables = Set<AnyCancellable>()
    
    // Dependency injection for IngredientsViewModel
    let ingredientsViewModel: IngredientsViewModel
    
    init(ingredientsViewModel: IngredientsViewModel) {
        self.ingredientsViewModel = ingredientsViewModel
        
        // Load saved recipes from CoreData
        savedRecipes = CoreDataManager.shared.fetchSavedRecipes()
        
        // Subscribe to recipe changes from IngredientsViewModel
        ingredientsViewModel.$recipes
            .map { recipes in
                recipes.filter { $0.isLiked }
            }
            .sink { [weak self] recipes in
                self?.savedRecipes = recipes
            }
            .store(in: &cancellables)
    }
    
    // Method for removing recipe from saved
    func toggleRecipeLike(_ recipe: Recipe) {
        ingredientsViewModel.toggleRecipeLike(recipe)
    }
    
    // Method for expanding/collapsing recipe description
    func toggleRecipeExpansion(_ recipe: Recipe) {
        ingredientsViewModel.toggleRecipeExpansion(recipe)
    }
} 
