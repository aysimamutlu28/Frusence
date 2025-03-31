import Foundation
import SwiftUI
import Combine

class OnboardingViewModel: ObservableObject {
    private var cancellables: Set<AnyCancellable> = []
    private let coordinator: MainCoordinator
    
    init(coordinator: MainCoordinator) {
        self.coordinator = coordinator
    }
    
    func continueTapped() {
        coordinator.navigate(to: .onboardingForm)
    }
    
    
    deinit {
        cancellables.forEach { $0.cancel() }
    }
} 
