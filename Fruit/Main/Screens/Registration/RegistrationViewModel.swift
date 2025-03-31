import Foundation
import SwiftUI
import Combine

class RegistrationViewModel: ObservableObject {
    @Published var name: String = ""
    @Published var email: String = ""
    @Published var password: String = ""
    @Published var confirmPassword: String = ""
    @Published var isLoading: Bool = false
    @Published var errorMessage: String?
    
    private var cancellables: Set<AnyCancellable> = []
    private let coordinator: MainCoordinator
    private let authService = AuthService.shared
    
    init(coordinator: MainCoordinator) {
        self.coordinator = coordinator
    }
    
    func logInTapped() {
        coordinator.navigate(to: .login)
    }
    
    func createAccountTapped() {
        guard validateInputs() else { return }
        
        isLoading = true
        errorMessage = nil
        
        authService.registerUser(withEmail: email, password: password, name: name)
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
    
    func anonymousTapped() {
        // Skip Firebase interaction, go directly to onboarding
        navigateToOnboarding()
    }
    
    private func validateInputs() -> Bool {
        // Check for empty fields
        if name.isEmpty || email.isEmpty || password.isEmpty || confirmPassword.isEmpty {
            errorMessage = "All fields must be filled"
            return false
        }
        
        // Check passwords match
        if password != confirmPassword {
            errorMessage = "Passwords don't match"
            return false
        }
        
        // Check email validity
        if !isValidEmail(email) {
            errorMessage = "Invalid email format"
            return false
        }
        
        // Check password length (Firebase requires minimum 6 characters)
        if password.count < 6 {
            errorMessage = "Password must contain at least 6 characters"
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
        case 17007: // EMAIL_ALREADY_IN_USE
            errorMessage = "This email is already in use"
        case 17008: // INVALID_EMAIL
            errorMessage = "Invalid email format"
        case 17026: // WEAK_PASSWORD
            errorMessage = "Password is too weak"
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
