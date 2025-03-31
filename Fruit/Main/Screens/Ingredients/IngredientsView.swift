import SwiftUI

struct IngredientsView: View {
    @StateObject var viewModel: IngredientsViewModel
    
    var body: some View {
        ZStack {
            // Background
            ZStack {
                Image("background")
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .ignoresSafeArea()
            }
            
            // Main Content
            VStack(alignment: .leading, spacing: 0) {
                Text(viewModel.showRecipes ? "Recipes:" : "Ingredients:")
                    .appFont(.clashDisplay, size: AppFontSize.motivation)
                    .foregroundColor(.milkColor)
                    .padding(.horizontal, 10)
                    .padding(.bottom, 10)
                    .padding(.top, 120)
                
                if viewModel.showRecipes {
                    // Recipes List
                    ScrollView {
                        LazyVStack(spacing: 5) {
                            ForEach(viewModel.recipes) { recipe in
                                RecipeCell(recipe: recipe, viewModel: viewModel)
                                    .padding(.horizontal, 10)
                            }
                        }
                    }
                    .frame(height: 340)
                    .transition(.asymmetric(
                        insertion: .move(edge: .trailing).combined(with: .opacity),
                        removal: .move(edge: .leading).combined(with: .opacity)
                    ))
                } else {
                    ZStack {
                        // Ingredients table
                        ScrollView {
                            LazyVStack(spacing: 5) {
                                ForEach(viewModel.ingredients) { ingredient in
                                    IngredientCell(ingredient: ingredient, viewModel: viewModel)
                                        .padding(.horizontal, 10)
                                }
                            }
                        }
                        .frame(height: 340)
                        
                        if viewModel.isProcessing {
                            VStack {
                                ProgressView()
                                    .scaleEffect(1.5)
                                Text("Recognizing fruits...")
                                    .foregroundColor(.secondary)
                                    .padding(.top, 8)
                            }
                            .frame(maxWidth: .infinity, maxHeight: .infinity)
                            .background(Color.black.opacity(0.2))
                        }
                    }
                    .opacity(viewModel.showMixAnimation ? 0 : 1)
                }
                
                Spacer()
                
                // Buttons
                if !viewModel.showRecipes {
                    VStack(spacing: 20) {
                        Button {
                            viewModel.addNewIngredient()
                        } label: {
                            Image("addIngredient")
                                .resizable()
                                .scaledToFit()
                        }
                        .withDefaultShadow()
                        
                        Button {
                            viewModel.mixIngredients()
                        } label: {
                            Image("mix")
                                .resizable()
                                .scaledToFit()
                        }
                        .withDefaultShadow()
                    }
                    .padding(.horizontal, 10)
                    .padding(.bottom, 140)
                    .opacity(viewModel.showMixAnimation ? 0 : 1)
                }
            }
            .padding(.horizontal, 10)
            
            // Mixing Animation
            if viewModel.showMixAnimation {
                LaunchView(loadingText: "Mixing")
                    .transition(.opacity)
            }
            
            // Top Rectangle Layer
            VStack {
                ZStack {
                    Color(red: 26/255, green: 7/255, blue: 55/255, opacity: 1)
                    
                    // Inner light rectangle
                    RoundedRectangle(cornerRadius: 10)
                        .fill(Color(red: 249/255, green: 237/255, blue: 255/255, opacity: 1))
                        .frame(width: UIScreen.main.bounds.width * 0.3, height: 12)
                        .padding(.top, 25)
                }
                .frame(height: 65)
                Spacer()
            }
            .ignoresSafeArea()
            .padding(.top, 30)
        }
        .animation(.easeInOut(duration: 0.5), value: viewModel.showMixAnimation)
        .animation(.easeInOut(duration: 0.5), value: viewModel.showRecipes)
        .onDisappear {
            viewModel.resetState()
        }
    }
}

struct IngredientsView_Previews: PreviewProvider {
    static var previews: some View {
        IngredientsView(viewModel: IngredientsViewModel(onboardingSettings: OnboardingFormViewModel(coordinator: MainCoordinator())))
    }
} 
