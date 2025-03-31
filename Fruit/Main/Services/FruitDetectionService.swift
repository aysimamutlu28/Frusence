import Foundation

enum FruitDetectionEvents {
    static let newFruitDetected = Notification.Name("newFruitDetected")
}

class FruitDetectionService {
    static let shared = FruitDetectionService()
    
    private init() {}
    
    func notifyNewFruitDetected(_ fruitName: String) {
        NotificationCenter.default.post(
            name: FruitDetectionEvents.newFruitDetected,
            object: nil,
            userInfo: ["fruitName": fruitName]
        )
    }
    
    func subscribeFruitDetection(_ observer: Any, selector: Selector) {
        NotificationCenter.default.addObserver(
            observer,
            selector: selector,
            name: FruitDetectionEvents.newFruitDetected,
            object: nil
        )
    }
    
    func unsubscribeFruitDetection(_ observer: Any) {
        NotificationCenter.default.removeObserver(
            observer,
            name: FruitDetectionEvents.newFruitDetected,
            object: nil
        )
    }
} 