import Foundation
import SwiftUI
import Combine
import FirebaseAuth

class ProfileViewModel: ObservableObject {
    @Published var isLoading: Bool = false
    @Published var errorMessage: String?
    @Published var isUserLoggedIn: Bool = false
    @Published var userEmail: String = ""
    @Published var userName: String = ""
    
    private var cancellables: Set<AnyCancellable> = []
    private let authService = AuthService.shared
    
    // For use in a presented sheet
    @Environment(\.dismiss) private var dismiss
    
    init() {
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
    
    func closeTapped() {
        dismiss()
    }
    
    deinit {
        cancellables.forEach { $0.cancel() }
    }
} 