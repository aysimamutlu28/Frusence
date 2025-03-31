import SwiftUI

struct RecipeCell: View {
    @ObservedObject var viewModel: IngredientsViewModel
    let recipe: Recipe
    @State private var rotationAngle: Double = 0
    
    init(recipe: Recipe, viewModel: IngredientsViewModel) {
        self.recipe = recipe
        self.viewModel = viewModel
        // Set initial rotation angle according to recipe state
        _rotationAngle = State(initialValue: recipe.isExpanded ? -90 : 0)
    }
    
    var body: some View {
        VStack(spacing: 0) {
            HStack(spacing: 0) {
                // Text field with recipe name
                Text(recipe.name)
                    .foregroundColor(.milkColor)
                    .appFont(.funnelRegular, size: AppFontSize.placeholder)
                    .padding(.horizontal, 16)
                
                Spacer()
                
                // Like button
                Button {
                    viewModel.toggleRecipeLike(recipe)
                } label: {
                    Image(recipe.isLiked ? "liked" : "like")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 60, height: 60)
                }
                .frame(maxHeight: .infinity)
                .withDefaultShadow()
                
                // Open button
                Button {
                    withAnimation(.spring()) {
                        viewModel.toggleRecipeExpansion(recipe)
                        rotationAngle += recipe.isExpanded ? -90 : 90
                    }
                } label: {
                    Image("open")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 60, height: 60)
                        .rotationEffect(.degrees(rotationAngle))
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
            
            // Recipe description
            if recipe.isExpanded {
                Text(recipe.description)
                    .foregroundColor(.milkColor)
                    .appFont(.funnelRegular, size: AppFontSize.description)
                    .padding(16)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .background(Color.clear)
                    .transition(.move(edge: .top).combined(with: .opacity))
            }
        }
    }
} 
