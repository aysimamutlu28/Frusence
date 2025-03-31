import SwiftUI

struct IngredientCell: View {
    @ObservedObject var viewModel: IngredientsViewModel
    var ingredient: Ingredient
    @State private var ingredientName: String
    
    init(ingredient: Ingredient, viewModel: IngredientsViewModel) {
        self.ingredient = ingredient
        self.viewModel = viewModel
        _ingredientName = State(initialValue: ingredient.name)
    }
    
    var body: some View {
        HStack(spacing: 0) {
            // Text field for editing ingredient name
            TextField("", text: $ingredientName)
                .foregroundColor(.milkColor)
                .appFont(.funnelRegular, size: AppFontSize.placeholder)
                .onChange(of: ingredientName) { newValue in
                    viewModel.updateIngredient(ingredient, newName: newValue)
                }
                .padding(.horizontal, 16)
            
            // Delete button
            Button {
                viewModel.removeIngredient(ingredient)
            } label: {
                Image("delete")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 60, height: 60)
            }
            .frame(maxHeight: .infinity)
            .withDefaultShadow()
        }
        .frame(maxWidth: .infinity, maxHeight: 60)
        .background(Color.clear)
        .overlay(
            RoundedRectangle(cornerRadius: 10)
                .stroke(Color(red: 122/255, green: 34/255, blue: 158/255, opacity: 1), lineWidth: 1)
        )
    }
} 
