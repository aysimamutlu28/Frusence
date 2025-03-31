import SwiftUI

struct AuthorizationView: View {
    @StateObject var viewModel: AuthorizationViewModel
    
    var body: some View {
        ZStack {
            VStack(spacing: 0) {
                Spacer()
                
                Image("cocktail")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 160)
                    .padding(.top, 20)
                
                if let errorMessage = viewModel.errorMessage {
                    Text(errorMessage)
                        .appFont(.funnelRegular, size: AppFontSize.placeholder)
                        .foregroundColor(.red)
                        .padding(.horizontal)
                        .padding(.top, 5)
                        .background(Color.white.opacity(0.7))
                        .cornerRadius(10)
                }
                
                Spacer()
                
                VStack(spacing: 0) {
                    if viewModel.isUserLoggedIn {
                        // User info if logged in
                        VStack(alignment: .leading, spacing: 5) {
                            Text("Email: \(viewModel.userEmail)")
                                .appFont(.clashDisplay, size: AppFontSize.motivation)
                                .foregroundColor(.milkColor)
                            
                            if !viewModel.userName.isEmpty && viewModel.userName != "No Name" {
                                Text("Name: \(viewModel.userName)")
                                    .appFont(.clashDisplay, size: AppFontSize.motivation)
                                    .foregroundColor(.milkColor)
                            }
                        }
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding(.bottom, 20)
                        .padding(.horizontal, 5)
                        
                        // Log Out Button
                        Button {
                            viewModel.logOutTapped()
                        } label: {
                            Capsule()
                                .fill(Color(red: 115/255, green: 15/255, blue: 101/255))
                                .overlay(
                                    Capsule()
                                        .stroke(Color(red: 227/255, green: 36/255, blue: 221/255), lineWidth: 2)
                                )
                                .overlay(
                                    Text("Log Out")
                                        .appFont(.funnelBold, size: AppFontSize.motivation)
                                        .foregroundColor(.milkColor)
                                )
                                .frame(height: 50)
                                .padding(5)
                        }
                        .withDefaultShadow()
                        .disabled(viewModel.isLoading)
                        
                        // Delete Account Button
                        Button {
                            viewModel.deleteAccountTapped()
                        } label: {
                            Capsule()
                                .fill(Color(red: 51/255, green: 2/255, blue: 45/255))
                                .overlay(
                                    Capsule()
                                        .stroke(Color(red: 227/255, green: 36/255, blue: 221/255), lineWidth: 2)
                                )
                                .overlay(
                                    Text("Delete Account")
                                        .appFont(.funnelBold, size: AppFontSize.motivation)
                                        .foregroundColor(.milkColor)
                                )
                                .frame(height: 50)
                                .padding(5)
                        }
                        .withDefaultShadow()
                        .disabled(viewModel.isLoading)
                        
                        // Continue Button
                        Button {
                            viewModel.continueTapped()
                        } label: {
                            Capsule()
                                .fill(Color(red: 236/255, green: 20/255, blue: 164/255))
                                .overlay(
                                    Text("Continue")
                                        .appFont(.funnelBold, size: AppFontSize.motivation)
                                        .foregroundColor(.milkColor)
                                )
                                .frame(height: 50)
                                .padding(5)
                                .padding(.bottom, 20)
                        }
                        .withDefaultShadow()
                        .disabled(viewModel.isLoading)
                    } else {
                        // Original content for non-logged in users
                        Text("Enjoy the flavor of\ncocktails and the\nease of making\nthem")
                            .appFont(.clashDisplay, size: AppFontSize.motivation)
                            .foregroundColor(.milkColor)
                            .multilineTextAlignment(.leading)
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .padding(.bottom, 20)
                            .padding(.horizontal, 5)
                        
                        Button {
                            viewModel.logInTapped()
                        } label: {
                            Image("logInMain")
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .padding(5)
                        }
                        .withDefaultShadow()
                        .disabled(viewModel.isLoading)
                        
                        Button {
                            viewModel.createAccountTapped()
                        } label: {
                            Image("createAnAccount")
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .padding(5)
                        }
                        .withDefaultShadow()
                        .disabled(viewModel.isLoading)
                        
                        Button {
                            viewModel.anonymousTapped()
                        } label: {
                            Image("anonimous")
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .padding(5)
                                .padding(.bottom, 40)
                        }
                        .withDefaultShadow()
                        .disabled(viewModel.isLoading)
                    }
                }
                .padding(.horizontal, 5)
                .padding(.bottom, viewModel.isUserLoggedIn ? 40 : 0)
            }
            
            if viewModel.isLoading {
                ProgressView()
                    .progressViewStyle(CircularProgressViewStyle(tint: Color.pinkColor))
                    .scaleEffect(1.5)
                    .background(Color.white.opacity(0.7))
                    .frame(width: 80, height: 80)
                    .cornerRadius(10)
            }
        }
    }
}

struct AuthorizationView_Previews: PreviewProvider {
    static var previews: some View {
        AuthorizationView(viewModel: AuthorizationViewModel(coordinator: MainCoordinator()))
    }
} 
