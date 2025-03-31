import SwiftUI

extension View {
    func placeholder<Content: View>(
        when shouldShow: Bool,
        alignment: Alignment = .leading,
        @ViewBuilder placeholder: () -> Content) -> some View {
        
        ZStack(alignment: alignment) {
            placeholder().opacity(shouldShow ? 1 : 0)
            self
        }
    }
}

extension View {
    func withDefaultShadow() -> some View {
        self.shadow(
            color: Color.black.opacity(0.25),
            radius: 10,
            x: 0,
            y: 4
        )
    }
}
