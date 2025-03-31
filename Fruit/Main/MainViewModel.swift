import Foundation
import SwiftUI
import Combine

class MainViewModel: ObservableObject {
    @Published var isShowingLaunchScreen = true
    private let coordinator: MainCoordinator
    private var cancellables: Set<AnyCancellable> = []
    
    init(coordinator: MainCoordinator) {
        self.coordinator = coordinator
        Timer.publish(every: 4, on: .main, in: .common)
            .autoconnect()
            .sink { [weak self] _ in
                withAnimation {
                    self?.isShowingLaunchScreen = false
                    self?.coordinator.navigate(to: .authorization)
                }
            }
            .store(in: &cancellables)
    }
    
    deinit {
        cancellables.forEach { $0.cancel() }
    }
} 
