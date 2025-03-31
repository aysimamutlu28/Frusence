import Foundation
import SwiftUI
import Combine

class LogInViewModel: ObservableObject {
    @Published var email: String = ""
    @Published var password: String = ""
    @Published var isLoading: Bool = false
    @Published var errorMessage: String?
    
    private var cancellables: Set<AnyCancellable> = []
    private let coordinator: MainCoordinator
    private let authService = AuthService.shared
    
    init(coordinator: MainCoordinator) {
        self.coordinator = coordinator
    }
    
    func logInTapped() {
        guard validateInputs() else { return }
        
        isLoading = true
        errorMessage = nil
        
        authService.loginUser(withEmail: email, password: password)
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: { [weak self] completion in
                self?.isLoading = false
                
                if case .failure(let error) = completion {
                    self?.handleError(error)
                }
            }, receiveValue: { [weak self] user in
                self?.navigateToOnboarding()
            })
            .store(in: &cancellables)
    }
    
    func createAccountTapped() {
        coordinator.navigate(to: .registration)
    }
    
    func anonymousTapped() {
        // Skip Firebase interaction, go directly to onboarding
        navigateToOnboarding()
    }
    
    private func validateInputs() -> Bool {
        // Check for empty fields
        if email.isEmpty || password.isEmpty {
            errorMessage = "All fields must be filled"
            return false
        }
        
        // Check email validity
        if !isValidEmail(email) {
            errorMessage = "Invalid email format"
            return false
        }
        
        return true
    }
    
    private func isValidEmail(_ email: String) -> Bool {
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        let emailPred = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailPred.evaluate(with: email)
    }
    
    private func handleError(_ error: Error) {
        let nsError = error as NSError
        
        // Handle different Firebase errors
        switch nsError.code {
        case 17009: // WRONG_PASSWORD
            errorMessage = "Wrong password"
        case 17011: // USER_NOT_FOUND
            errorMessage = "User with this email not found"
        case 17008: // INVALID_EMAIL
            errorMessage = "Invalid email format"
        default:
            errorMessage = error.localizedDescription
        }
    }
    
    private func navigateToOnboarding() {
        coordinator.navigate(to: .onboarding)
    }
    
    deinit {
        cancellables.forEach { $0.cancel() }
    }
}
