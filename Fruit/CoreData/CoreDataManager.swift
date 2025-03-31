import CoreData
import Foundation

// Transformer for string array
@objc(StringArrayTransformer)
class StringArrayTransformer: NSSecureUnarchiveFromDataTransformer {
    override class var allowedTopLevelClasses: [AnyClass] {
        return [NSArray.self, NSString.self]
    }
    
    static func register() {
        let className = String(describing: StringArrayTransformer.self)
        let name = NSValueTransformerName(className)
        
        let transformer = StringArrayTransformer()
        ValueTransformer.setValueTransformer(transformer, forName: name)
    }
}

class CoreDataManager {
    static let shared = CoreDataManager()
    
    private init() {}
    
    private var storeURL: URL {
        let urls = FileManager.default.urls(for: .applicationSupportDirectory, in: .userDomainMask)
        let appSupportURL = urls[0]
        return appSupportURL.appendingPathComponent("FruitModel.sqlite")
    }
    
    private func recreateStore() {
        // Delete database file
        try? FileManager.default.removeItem(at: storeURL)
        
        // Clear coordinator
        for store in persistentContainer.persistentStoreCoordinator.persistentStores {
            try? persistentContainer.persistentStoreCoordinator.remove(store)
        }
        
        // Reload database
        persistentContainer.loadPersistentStores { description, error in
            if let error = error {
                print("Error recreating database: \(error)")
            }
        }
    }
    
    lazy var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "FruitModel")
        
        // Configure options for automatic migration
        let description = NSPersistentStoreDescription()
        description.url = storeURL
        description.shouldMigrateStoreAutomatically = true
        description.shouldInferMappingModelAutomatically = true
        container.persistentStoreDescriptions = [description]
        
        container.loadPersistentStores { description, error in
            if let error = error {
                print("Error loading Core Data: \(error)")
                
                // If an error occurred, try to recreate the database
                self.recreateStore()
            }
        }
        return container
    }()
    
    var context: NSManagedObjectContext {
        persistentContainer.viewContext
    }
    
    func saveContext() {
        guard persistentContainer.persistentStoreCoordinator.persistentStores.count > 0 else {
            print("No data stores available")
            return
        }
        
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                print("Error saving context: \(error)")
                
                // If a save error occurred, try to recreate the database
                recreateStore()
            }
        }
    }
    
    // MARK: - Recipe operations
    
    func saveRecipe(_ recipe: Recipe) {
        // Check if recipe already exists
        let fetchRequest: NSFetchRequest<SavedRecipe> = SavedRecipe.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "id == %@", recipe.id as CVarArg)
        
        do {
            let results = try context.fetch(fetchRequest)
            if results.isEmpty {
                // Create new recipe
                let savedRecipe = SavedRecipe(context: context)
                savedRecipe.id = recipe.id
                savedRecipe.name = recipe.name
                savedRecipe.desc = recipe.description
                
                // Convert array to JSON string
                let ingredientsData = try JSONSerialization.data(withJSONObject: recipe.ingredients, options: [])
                if let ingredientsString = String(data: ingredientsData, encoding: .utf8) {
                    savedRecipe.ingredients = ingredientsString
                }
                
                savedRecipe.recipeType = recipe.type.rawValue
                savedRecipe.isExpanded = recipe.isExpanded
                
                saveContext()
            }
        } catch {
            print("Error saving recipe: \(error)")
        }
    }
    
    func deleteRecipe(_ recipe: Recipe) {
        let fetchRequest: NSFetchRequest<SavedRecipe> = SavedRecipe.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "id == %@", recipe.id as CVarArg)
        
        do {
            let results = try context.fetch(fetchRequest)
            if let savedRecipe = results.first {
                context.delete(savedRecipe)
                saveContext()
            }
        } catch {
            print("Error deleting recipe: \(error)")
        }
    }
    
    func fetchSavedRecipes() -> [Recipe] {
        let fetchRequest: NSFetchRequest<SavedRecipe> = SavedRecipe.fetchRequest()
        
        do {
            let savedRecipes = try context.fetch(fetchRequest)
            return savedRecipes.compactMap { savedRecipe in
                guard let id = savedRecipe.id,
                      let name = savedRecipe.name,
                      let description = savedRecipe.desc,
                      let ingredientsString = savedRecipe.ingredients,
                      let ingredientsData = ingredientsString.data(using: .utf8),
                      let ingredients = try? JSONSerialization.jsonObject(with: ingredientsData) as? [String],
                      let typeString = savedRecipe.recipeType,
                      let type = RecipeType(rawValue: typeString) else {
                    return nil
                }
                
                return Recipe(
                    id: id,
                    name: name,
                    description: description,
                    ingredients: ingredients,
                    type: type,
                    isLiked: true,
                    isExpanded: savedRecipe.isExpanded
                )
            }
        } catch {
            print("Error fetching saved recipes: \(error)")
            return []
        }
    }
    
    func updateRecipeExpansion(_ recipe: Recipe) {
        let fetchRequest: NSFetchRequest<SavedRecipe> = SavedRecipe.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "id == %@", recipe.id as CVarArg)
        
        do {
            let results = try context.fetch(fetchRequest)
            if let savedRecipe = results.first {
                savedRecipe.isExpanded = recipe.isExpanded
                saveContext()
            }
        } catch {
            print("Error updating recipe expansion state: \(error)")
        }
    }
} 