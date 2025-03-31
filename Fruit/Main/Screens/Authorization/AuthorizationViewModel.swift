import Foundation
import SwiftUI
import Combine
import FirebaseAuth

class AuthorizationViewModel: ObservableObject {
    @Published var isLoading: Bool = false
    @Published var errorMessage: String?
    @Published var isUserLoggedIn: Bool = false
    @Published var userEmail: String = ""
    @Published var userName: String = ""
    
    private var cancellables: Set<AnyCancellable> = []
    private let coordinator: MainCoordinator
    private let authService = AuthService.shared
    
    init(coordinator: MainCoordinator) {
        self.coordinator = coordinator
        checkAuthState()
    }
    
    private func checkAuthState() {
        if let user = authService.currentUser {
            isUserLoggedIn = true
            userEmail = user.email ?? "No Email"
            userName = user.displayName ?? "No Name"
        } else {
            isUserLoggedIn = false
            userEmail = ""
            userName = ""
        }
    }
    
    func logInTapped() {
        coordinator.navigate(to: .login)
    }
    
    func createAccountTapped() {
        coordinator.navigate(to: .registration)
    }
    
    func anonymousTapped() {
        coordinator.navigate(to: .onboarding)
    }
    
    func logOutTapped() {
        isLoading = true
        errorMessage = nil
        
        authService.signOut()
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: { [weak self] completion in
                self?.isLoading = false
                
                if case .failure(let error) = completion {
                    self?.errorMessage = error.localizedDescription
                }
                
                self?.checkAuthState()
            }, receiveValue: { [weak self] _ in
                self?.checkAuthState()
            })
            .store(in: &cancellables)
    }
    
    func deleteAccountTapped() {
        isLoading = true
        errorMessage = nil
        
        if let user = Auth.auth().currentUser {
            user.delete { [weak self] error in
                DispatchQueue.main.async {
                    self?.isLoading = false
                    
                    if let error = error {
                        self?.errorMessage = error.localizedDescription
                    } else {
                        self?.checkAuthState()
                    }
                }
            }
        } else {
            isLoading = false
            errorMessage = "User not found"
        }
    }
    
    func continueTapped() {
        coordinator.navigate(to: .onboarding)
    }
    
    deinit {
        cancellables.forEach { $0.cancel() }
    }
} 
