import Foundation
import SwiftUI
import Combine

class LaunchViewModel: ObservableObject {
    @Published var phase: CGFloat = 0
    @Published var yOffset: CGFloat = UIScreen.main.bounds.height - 550
    
    private var cancellables: Set<AnyCancellable> = []
    
    init() {
        Timer.publish(every: 0.0165, on: .main, in: .common)
            .autoconnect()
            .sink { [weak self] _ in
                guard let self = self else { return }
                
                self.phase += 0.075
                
                if self.phase > 2 * .pi {
                    self.phase = 0
                }
            }
            .store(in: &cancellables)
            
        DispatchQueue.main.async {
            self.startWaveAnimation()
        }
    }
    
    func startWaveAnimation() {
        withAnimation(.easeInOut(duration: 4.0)) {
            yOffset = -50
        }
    }
    
    deinit {
        cancellables.forEach { $0.cancel() }
    }
} 
