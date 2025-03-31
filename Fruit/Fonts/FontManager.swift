import SwiftUI

// MARK: - Font Style
enum AppFontStyle: String {
    case funnelRegular = "FunnelSans-Regular"
    case clashDisplay = "ClashDisplay-Medium"
    case funnelBold = "FunnelSans-SemiBold"
    
    func size(_ size: CGFloat) -> Font {
        return .custom(self.rawValue, size: size)
    }
}

// MARK: - Font Size
enum AppFontSize {
    static let loading: CGFloat = 64
    static let motivation: CGFloat = 34
    static let title: CGFloat = 46
    static let placeholder: CGFloat = 22
    static let description: CGFloat = 16
    static let onboarding: CGFloat = 26
}

// MARK: - Font Colors
extension Color {
    static let milkColor = Color(red: 249/255, green: 237/255, blue: 255/255, opacity: 1)
    static let pinkColor = Color(red: 203/255, green: 154/255, blue: 227/255, opacity: 1)
}

// MARK: - Font Extension
extension Font {
    static func appFont(_ style: AppFontStyle, size: CGFloat) -> Font {
        return style.size(size)
    }
}

// MARK: - View Extension
extension View {
    func appFont(_ style: AppFontStyle, size: CGFloat) -> some View {
        self.font(.appFont(style, size: size))
    }
} 
