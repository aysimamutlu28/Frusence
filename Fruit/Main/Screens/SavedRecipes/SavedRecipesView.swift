import SwiftUI

struct SavedRecipesView: View {
    @StateObject private var viewModel: SavedRecipesViewModel
    @State private var showProfileSheet = false
    @Binding var selectedTab: TabItem
    
    init(ingredientsViewModel: IngredientsViewModel, selectedTab: Binding<TabItem>) {
        _viewModel = StateObject(wrappedValue: SavedRecipesViewModel(ingredientsViewModel: ingredientsViewModel))
        _selectedTab = selectedTab
    }
    
    var body: some View {
        GeometryReader { geometry in
            ZStack {
                Image("background")
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(
                        width: UIScreen.main.bounds.width,
                        height: UIScreen.main.bounds.height + geometry.safeAreaInsets.bottom
                    )
                    .ignoresSafeArea()
                
                VStack(spacing: 0) {
                    // Header
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
                    .padding(.top, geometry.safeAreaInsets.top + 60)
                    
                    // Content
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
                            .padding(.bottom, 16)
                        }
                    }
                    
                    // Bottom navigation menu
                    BottomNavigationBar(selectedTab: $selectedTab)
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity)
            }
        }
        .ignoresSafeArea()
        .sheet(isPresented: $showProfileSheet) {
            ProfileView()
        }
    }
} 
