import SwiftUI

struct OnboardingView: View {
    @StateObject var viewModel: OnboardingViewModel
    
    var body: some View {
            
            VStack(spacing: 0) {
                Spacer()
                
                Image("fruits")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .padding(.top, 20)
                
                
                Spacer()
                
                VStack(spacing: 0) {
                    
                    Text("Create a delicious smoothie with whatever")
                        .appFont(.clashDisplay, size: AppFontSize.motivation)
                        .foregroundColor(.milkColor)
                        .multilineTextAlignment(.leading)
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding(.bottom, 20)
                        .padding(.horizontal, 5)
                    
                    
                    
                    Button {
                        viewModel.continueTapped()
                    } label: {
                        Image("continue")
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .padding(5)
                            .padding(.bottom, 40)
                    }
                }
                .padding(.horizontal, 5)
                
            }
        }
    
}

struct OnboardingView_Previews: PreviewProvider {
    static var previews: some View {
        OnboardingView(viewModel: OnboardingViewModel(coordinator: MainCoordinator()))
    }
} 
