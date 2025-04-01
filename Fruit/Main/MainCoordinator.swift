import SwiftUI

enum AppRoute {
    case launch
    case authorization
    case login
    case registration
    case onboarding
    case onboardingForm
}

class MainCoordinator: ObservableObject {
    @Published var currentRoute: AppRoute = .launch
    private let authService = AuthService.shared
    
    func navigate(to route: AppRoute) {
        currentRoute = route
    }
    
    func handleLaunchCompletion() {
        // Don't interrupt the animation that has already started in onAppear
        DispatchQueue.main.asyncAfter(deadline: .now() + 4) {
            withAnimation {
                // Check if user is logged in
                if self.authService.isUserLoggedIn {
                    // User is logged in, navigate directly to onboarding
                    self.navigate(to: .onboarding)
                } else {
                    // User is not logged in, show authorization screen
                    self.navigate(to: .authorization)
                }
            }
        }
    }
}

struct MainCoordinatorView: View {
    @StateObject private var coordinator = MainCoordinator()
    
    var body: some View {
        NavigationStack {
            GeometryReader { geometry in
                ZStack {
                    // Background
                    Image("background")
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                        .frame(
                            width: UIScreen.main.bounds.width,
                            height: UIScreen.main.bounds.height + geometry.safeAreaInsets.bottom
                        )
                        .ignoresSafeArea()
                        .edgesIgnoringSafeArea(.all)
                    
                    // Content
                    VStack(spacing: 0) {
                        switch coordinator.currentRoute {
                        case .launch:
                            LaunchView()
                                .onAppear {
                                    // Ensure enough time for the animation to start before transition
                                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                                        coordinator.handleLaunchCompletion()
                                    }
                                }
                        case .authorization:
                            AuthorizationView(viewModel: AuthorizationViewModel(coordinator: coordinator))
                        case .login:
                            LogInView(viewModel: LogInViewModel(coordinator: coordinator))
                        case .registration:
                            RegistrationView(viewModel: RegistrationViewModel(coordinator: coordinator))
                        case .onboarding:
                            OnboardingView(viewModel: OnboardingViewModel(coordinator: coordinator))
                        case .onboardingForm:
                            OnboardingFormView(
                                viewModel: OnboardingFormViewModel(coordinator: coordinator),
                                onComplete: {
                                    // Here we return to MainView with existing logic
                                    withAnimation {
                                        (UIApplication.shared.connectedScenes.first as? UIWindowScene)?.windows.first?.rootViewController = UIHostingController(rootView: MainView())
                                    }
                                }
                            )
                        }
                    }
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                }
            }
            .navigationBarHidden(true)
            .ignoresSafeArea(.all)
        }
    }
} 