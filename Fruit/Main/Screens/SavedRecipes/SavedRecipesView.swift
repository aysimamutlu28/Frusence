import SwiftUI

struct SavedRecipesView: View {
    @StateObject private var viewModel: SavedRecipesViewModel
    @State private var showProfileSheet = false
    
    init(ingredientsViewModel: IngredientsViewModel) {
        _viewModel = StateObject(wrappedValue: SavedRecipesViewModel(ingredientsViewModel: ingredientsViewModel))
    }
    
    var body: some View {
        ZStack {
            Image("background")
                .resizable()
                .aspectRatio(contentMode: .fill)
                .ignoresSafeArea(.all)
            
            VStack(spacing: 16) {
                HStack {
                    Text("Saved Recipes")
                        .foregroundColor(.milkColor)
                        .appFont(.funnelRegular, size: AppFontSize.title)
                        .frame(maxWidth: .infinity, alignment: .leading)
                    
                    Button {
                        showProfileSheet = true
                    } label: {
                        Image(systemName: "person.circle.fill")
                            .font(.system(size: 40))
                            .foregroundColor(.milkColor)
                    }
                }
                .padding(.horizontal, 26)
                .padding(.top, 60)
                
                if viewModel.savedRecipes.isEmpty {
                    Spacer()
                    Text("You don't have any saved recipes yet")
                        .foregroundColor(.milkColor)
                        .appFont(.funnelRegular, size: AppFontSize.placeholder)
                        .multilineTextAlignment(.center)
                        .padding(.horizontal, 32)
                    Spacer()
                } else {
                    ScrollView {
                        LazyVStack(spacing: 16) {
                            ForEach(viewModel.savedRecipes) { recipe in
                                RecipeCell(recipe: recipe, viewModel: viewModel.ingredientsViewModel)
                            }
                        }
                        .padding(.horizontal, 16)
                    }
                }
            }
        }
        .sheet(isPresented: $showProfileSheet) {
            ProfileView()
        }
    }
} 
