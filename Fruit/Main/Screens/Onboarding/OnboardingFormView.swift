import SwiftUI

struct OnboardingFormView: View {
    @StateObject var viewModel: OnboardingFormViewModel
    var onComplete: (() -> Void)?
    
    var body: some View {
        VStack {
            // Top texts
            HStack(alignment: .center) {
                Text("Specify your \npreferences")
                    .appFont(.funnelRegular, size: AppFontSize.onboarding)
                    .foregroundColor(.pinkColor)
                    .padding(.top, 40)
                
                Spacer()
                
                Text("0\(viewModel.currentPage)/05")
                    .appFont(.funnelRegular, size: AppFontSize.onboarding)
                    .foregroundColor(.pinkColor)
                    .padding(.top, 30)
            }
            .padding(.horizontal, 10)
            
            Rectangle()
                .fill(Color(red: 111/255, green: 28/255, blue: 157/255, opacity: 1))
                .frame(height: 1)
            
            // ZStack with 5 layers
            ZStack {
                // Layer 1 - Maximum number of fruits
                if viewModel.currentPage == 1 {
                    VStack(alignment: .leading, spacing: 20) {
                        Text("Maximum number of \nfruits in one drink")
                            .appFont(.clashDisplay, size: AppFontSize.motivation)
                            .foregroundColor(.milkColor)
                            .multilineTextAlignment(.leading)
                            .fixedSize(horizontal: false, vertical: true)
                        
                        VStack(spacing: 15) {
                            HStack(spacing: 15) {
                                fruitNumberButton(number: 1)
                                fruitNumberButton(number: 2)
                                fruitNumberButton(number: 3)
                            }
                            
                            HStack(spacing: 15) {
                                fruitNumberButton(number: 4)
                                fruitNumberButton(number: 5)
                                fruitNumberButton(number: 6)
                            }
                        }
                    }
                    .padding(.horizontal, 10)
                    .transition(.opacity)
                }
                
                // Layer 2 - Cereals
                if viewModel.currentPage == 2 {
                    VStack(alignment: .leading, spacing: 20) {
                        Text("Do you want cereals in \nthe drink?")
                            .appFont(.clashDisplay, size: AppFontSize.motivation)
                            .foregroundColor(.milkColor)
                            .multilineTextAlignment(.leading)
                            .fixedSize(horizontal: false, vertical: true)
                        
                        HStack(spacing: 15) {
                            yesNoButton(option: 1, forPage: 2) {
                                viewModel.selectCereals(true)
                            }
                            
                            yesNoButton(option: 2, forPage: 2) {
                                viewModel.selectCereals(false)
                            }
                        }
                    }
                    .padding(.horizontal, 10)
                    .transition(.opacity)
                }
                
                // Layer 3 - Seeds
                if viewModel.currentPage == 3 {
                    VStack(alignment: .leading, spacing: 20) {
                        Text("Do you want seeds in \nthe drink?")
                            .appFont(.clashDisplay, size: AppFontSize.motivation)
                            .foregroundColor(.milkColor)
                            .multilineTextAlignment(.leading)
                            .fixedSize(horizontal: false, vertical: true)
                        
                        HStack(spacing: 15) {
                            yesNoButton(option: 1, forPage: 3) {
                                viewModel.selectSeeds(true)
                            }
                            
                            yesNoButton(option: 2, forPage: 3) {
                                viewModel.selectSeeds(false)
                            }
                        }
                    }
                    .padding(.horizontal, 10)
                    .transition(.opacity)
                }
                
                // Layer 4 - Ice
                if viewModel.currentPage == 4 {
                    VStack(alignment: .leading, spacing: 20) {
                        Text("Do you want ice in \nthe drink?")
                            .appFont(.clashDisplay, size: AppFontSize.motivation)
                            .foregroundColor(.milkColor)
                            .multilineTextAlignment(.leading)
                            .fixedSize(horizontal: false, vertical: true)
                        
                        HStack(spacing: 15) {
                            yesNoButton(option: 1, forPage: 4) {
                                viewModel.selectIce(true)
                            }
                            
                            yesNoButton(option: 2, forPage: 4) {
                                viewModel.selectIce(false)
                            }
                        }
                    }
                    .padding(.horizontal, 10)
                    .transition(.opacity)
                }
                
                // Layer 5 - Yogurt
                if viewModel.currentPage == 5 {
                    VStack(alignment: .leading, spacing: 20) {
                        Text("Do you want yogurt in \nthe drink?")
                            .appFont(.clashDisplay, size: AppFontSize.motivation)
                            .foregroundColor(.milkColor)
                            .multilineTextAlignment(.leading)
                            .fixedSize(horizontal: false, vertical: true)
                        
                        HStack(spacing: 15) {
                            yesNoButton(option: 1, forPage: 5) {
                                viewModel.selectYogurt(true)
                            }
                            
                            yesNoButton(option: 2, forPage: 5) {
                                viewModel.selectYogurt(false)
                            }
                        }
                    }
                    .padding(.horizontal, 10)
                    .transition(.opacity)
                }
            }
            .padding(.top, 20)
            
            Spacer()
            
            // Bottom buttons
            HStack {
                Button {
                    viewModel.backTapped()
                } label: {
                    Image("back")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(height: 80)
                }
                .withDefaultShadow()
                
                Button {
                    if viewModel.currentPage == 5 {
                        onComplete?()
                    } else {
                        viewModel.nextTapped()
                    }
                } label: {
                    Image("next")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(height: 80)
                        .opacity(viewModel.isCurrentPageAnswered() ? 1.0 : 0.5)
                }
                .disabled(!viewModel.isCurrentPageAnswered())
                .withDefaultShadow()
            }
            .padding(.horizontal, 5)
            .padding(.bottom, 40)
        }
        .animation(.easeInOut, value: viewModel.currentPage)
    }
    
    // Button for selecting number of fruits
    private func fruitNumberButton(number: Int) -> some View {
        Button {
            viewModel.selectMaxFruits(number)
        } label: {
            Image("\(number)")
                .resizable()
                .aspectRatio(contentMode: .fit)
                .overlay(
                    RoundedRectangle(cornerRadius: 30)
                        .stroke(Color.white, lineWidth: viewModel.isOptionSelected(number, forPage: 1) ? 6 : 0)
                )
        }
    }
    
    // Yes/No button for other layers
    private func yesNoButton(option: Int, forPage page: Int, action: @escaping () -> Void) -> some View {
        Button {
            action()
        } label: {
            Image(option == 1 ? "yes" : "no")
                .resizable()
                .aspectRatio(contentMode: .fit)
                .overlay(
                    RoundedRectangle(cornerRadius: 30)
                        .stroke(Color.white, lineWidth: viewModel.isOptionSelected(option, forPage: page) ? 6 : 0)
                )
        }
    }
}

struct OnboardingFormView_Previews: PreviewProvider {
    static var previews: some View {
        OnboardingFormView(viewModel: OnboardingFormViewModel(coordinator: MainCoordinator()))
    }
}
