import Foundation
import SwiftUI
import Combine

class OnboardingFormViewModel: ObservableObject {
    private let coordinator: MainCoordinator
    @Published var currentPage: Int = 1
    @Published private var selectedOptions: [Int: Int] = [:]
    
    init(coordinator: MainCoordinator) {
        self.coordinator = coordinator
    }
    
    private var cancellables: Set<AnyCancellable> = []
    
    // Computed properties for compatibility
    var maxFruitsSelected: Int? {
        selectedOptions[1]
    }
    
    var wantsCereals: Bool? {
        guard let value = selectedOptions[2] else { return nil }
        return value == 1
    }
    
    var wantsSeeds: Bool? {
        guard let value = selectedOptions[3] else { return nil }
        return value == 1
    }
    
    var wantsIce: Bool? {
        guard let value = selectedOptions[4] else { return nil }
        return value == 1
    }
    
    var wantsYogurt: Bool? {
        guard let value = selectedOptions[5] else { return nil }
        return value == 1
    }
    
    func backTapped() {
        if currentPage > 1 {
            currentPage -= 1
        }
        print("Back button tapped, now at page \(currentPage)")
    }
    
    func nextTapped() {
        if currentPage < 5 {
            currentPage += 1
        }
        print("Next button tapped, now at page \(currentPage)")
    }
    
    func selectMaxFruits(_ number: Int) {
        selectedOptions[1] = number
        print("Selected \(number) as max fruits")
    }
    
    func selectCereals(_ isYes: Bool) {
        selectedOptions[2] = isYes ? 1 : 2
        print("Wants cereals: \(isYes)")
    }
    
    func selectSeeds(_ isYes: Bool) {
        selectedOptions[3] = isYes ? 1 : 2
        print("Wants seeds: \(isYes)")
    }
    
    func selectIce(_ isYes: Bool) {
        selectedOptions[4] = isYes ? 1 : 2
        print("Wants ice: \(isYes)")
    }
    
    func selectYogurt(_ isYes: Bool) {
        selectedOptions[5] = isYes ? 1 : 2
        print("Wants yogurt: \(isYes)")
    }
    
    func isOptionSelected(_ option: Int, forPage page: Int) -> Bool {
        return selectedOptions[page] == option
    }
    
    func isCurrentPageAnswered() -> Bool {
        return selectedOptions[currentPage] != nil
    }
    
    deinit {
        cancellables.forEach { $0.cancel() }
    }
}
