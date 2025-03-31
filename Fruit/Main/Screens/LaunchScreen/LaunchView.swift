import SwiftUI
import Foundation

struct LaunchView: View {
    @StateObject private var viewModel = LaunchViewModel()
    var loadingText: String
    
    init(loadingText: String = "Loading") {
        self.loadingText = loadingText
    }
    
    var body: some View {
        ZStack {
            
            // MARK: - The First Wave
            WaveShape(
                amplitude1: 15,
                frequency1: 2,
                amplitude2: 8,
                frequency2: 4,
                phase: viewModel.phase
            )
            .fill(Color(red: 219/255, green: 81/255, blue: 214/255, opacity: 1))
            .rotationEffect(.degrees(Foundation.sin(viewModel.phase) * 5))
            .offset(y: viewModel.yOffset)
            
            // MARK: - The Second Wave
            WaveShape(
                amplitude1: 15,
                frequency1: 2,
                amplitude2: 8,
                frequency2: 4,
                phase: -viewModel.phase + 0.5
            )
            .fill(Color(red: 253/255, green: 132/255, blue: 249/255, opacity: 1))
            .rotationEffect(.degrees(-Foundation.sin(viewModel.phase) * 5))
            .offset(x: 15, y: viewModel.yOffset + 10)
            
            // MARK: - Glass
            Image("launch")
                .resizable()
                .aspectRatio(contentMode: .fill)
            
            // MARK: - Loading
            VStack {
                Spacer()
                Text(loadingText)
                    .font(.appFont(.clashDisplay, size: AppFontSize.loading))
                    .foregroundColor(.milkColor)
                    .padding(.bottom, 170)
            }
        }
        .edgesIgnoringSafeArea(.all)
    }
}

struct LaunchView_Previews: PreviewProvider {
    static var previews: some View {
        LaunchView(loadingText: "Loading")
    }
}
