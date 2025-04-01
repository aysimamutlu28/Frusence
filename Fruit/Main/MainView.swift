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
            let window = UIApplication.shared.windows.first
            let bottomInset = window?.safeAreaInsets.bottom ?? 0
            
            Image("background")
                .resizable()
                .aspectRatio(contentMode: .fill)
                .frame(
                    width: UIScreen.main.bounds.width,
                    height: UIScreen.main.bounds.height + bottomInset
                )
                .ignoresSafeArea()
            
            if selectedTab == .camera {
                CameraView(
                    ingredientsViewModel: ingredientsViewModel,
                    showIngredients: $showIngredients,
                    selectedTab: $selectedTab
                )
                .transition(.opacity)
                .sheet(isPresented: $showIngredients) {
                    IngredientsView(viewModel: ingredientsViewModel)
                        .background(
                            Image("background")
                                .resizable()
                                .aspectRatio(contentMode: .fill)
                                .ignoresSafeArea()
                        )
                }
            } else {
                SavedRecipesView(
                    ingredientsViewModel: ingredientsViewModel,
                    selectedTab: $selectedTab
                )
                .transition(.opacity)
            }
        }
    }
}

#Preview {
    MainView()
}

