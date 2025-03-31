import SwiftUI

enum TabItem {
    case camera
    case savedRecipes
    
    var icon: String {
        switch self {
        case .camera:
            return "camera"
        case .savedRecipes:
            return "recipes"
        }
    }
    
    var selectedIcon: String {
        switch self {
        case .camera:
            return "cameraSelected"
        case .savedRecipes:
            return "recipesSelected"
        }
    }
}

struct BottomNavigationBar: View {
    @Binding var selectedTab: TabItem
    
    var body: some View {
        VStack {
            Spacer()
            
            ZStack(alignment: .top) {
                // Background with rounded top corners
                RoundedCornerShape(corners: [.topLeft, .topRight], radius: 40)
                    .fill(Color(red: 71/255, green: 9/255, blue: 110/255)) // rgba(71, 9, 110, 1)
                    .frame(height: 130)
                    .ignoresSafeArea(edges: .bottom)
                
                // Navigation buttons evenly distributed by width and raised up
                GeometryReader { geometry in
                    HStack(spacing: 0) {
                        tabButtonContainer(for: .camera, width: geometry.size.width / 2, height: geometry.size.height)
                        tabButtonContainer(for: .savedRecipes, width: geometry.size.width / 2, height: geometry.size.height)
                    }
                    .frame(height: geometry.size.height)
                    .offset(y: 0) // Position at the top of container
                }
                .frame(height: 105)
            }
        }
        .ignoresSafeArea(edges: .bottom)
    }
    
    @ViewBuilder
    private func tabButtonContainer(for tab: TabItem, width: CGFloat, height: CGFloat) -> some View {
        Button {
            withAnimation(.easeInOut) {
                selectedTab = tab
            }
        } label: {
            Image(selectedTab == tab ? tab.selectedIcon : tab.icon)
                .resizable()
                .scaledToFit()
                .frame(width: width * 0.9, height: height)
                .contentShape(Rectangle())
                .frame(width: width, height: height)
        }
        .buttonStyle(PlainButtonStyle())
        .withDefaultShadow()
    }
}

// Helper structure for creating a shape with rounded top corners
struct RoundedCornerShape: Shape {
    var corners: UIRectCorner
    var radius: CGFloat
    
    func path(in rect: CGRect) -> Path {
        let path = UIBezierPath(
            roundedRect: rect,
            byRoundingCorners: corners,
            cornerRadii: CGSize(width: radius, height: radius)
        )
        return Path(path.cgPath)
    }
}

#Preview {
    ZStack {
        Color.gray
        BottomNavigationBar(selectedTab: .constant(.camera))
    }
}
