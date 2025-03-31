import SwiftUI

struct MainView: View {
    @StateObject private var viewModel: MainViewModel
    @StateObject private var onboardingViewModel: OnboardingFormViewModel
    @StateObject private var ingredientsViewModel: IngredientsViewModel
    @State private var hasCompletedOnboarding = false
    @State private var showIngredients = false
    @State private var selectedTab: TabItem = .camera
    
    init() {
        let coordinator = MainCoordinator()
        _viewModel = StateObject(wrappedValue: MainViewModel(coordinator: coordinator))
        let onboardingVM = OnboardingFormViewModel(coordinator: coordinator)
        _onboardingViewModel = StateObject(wrappedValue: onboardingVM)
        _ingredientsViewModel = StateObject(wrappedValue: IngredientsViewModel(onboardingSettings: onboardingVM))
    }
    
    var body: some View {
        ZStack {
            Image("background")
                .resizable()
                .aspectRatio(contentMode: .fill)
                .ignoresSafeArea(.all)
            
            Group {
                if selectedTab == .camera {
                    CameraView(
                        ingredientsViewModel: ingredientsViewModel,
                        showIngredients: $showIngredients,
                        selectedTab: $selectedTab
                    )
                    .transition(.opacity)
                    .sheet(isPresented: $showIngredients) {
                        ZStack {
                            IngredientsView(viewModel: ingredientsViewModel)
                                .background(
                                    Image("background")
                                        .resizable()
                                        .aspectRatio(contentMode: .fill)
                                        .ignoresSafeArea()
                                )
                            
                            VStack {
                                Spacer()
                                BottomNavigationBar(selectedTab: Binding(
                                    get: { selectedTab },
                                    set: { newTab in
                                        if newTab != selectedTab {
                                            if newTab == .savedRecipes {
                                                showIngredients = false
                                                DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                                                    selectedTab = newTab
                                                }
                                            } else {
                                                selectedTab = newTab
                                            }
                                        }
                                    }
                                ))
                            }
                        }
                    }
                } else {
                    SavedRecipesView(ingredientsViewModel: ingredientsViewModel)
                        .transition(.opacity)
                }
            }
            
            // Bottom menu for fullscreen mode
            if !showIngredients {
                VStack {
                    Spacer()
                    BottomNavigationBar(selectedTab: $selectedTab)
                }
            }
        }
    }
}

#Preview {
    MainView()
}

