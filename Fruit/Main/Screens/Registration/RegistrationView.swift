import SwiftUI

struct RegistrationView: View {
    @StateObject var viewModel: RegistrationViewModel
    
    var body: some View {
        GeometryReader { geometry in
            // Calculate proportional height for text fields
            let textFieldHeight = geometry.size.height * 0.06 // Adjust multiplier as needed
            
            ZStack {
                VStack {
                    Text("Registration")
                        .appFont(.funnelBold, size: AppFontSize.title)
                        .foregroundColor(.pinkColor)
                        .frame(maxWidth: .infinity, alignment: .center)
                        .padding(.top, 40)
                    
                    Rectangle()
                        .fill(Color(red: 111/255, green: 28/255, blue: 157/255, opacity: 1))
                        .frame(height: 1)
                    
                    if let errorMessage = viewModel.errorMessage {
                        Text(errorMessage)
                            .appFont(.funnelRegular, size: AppFontSize.placeholder)
                            .foregroundColor(.red)
                            .padding(.horizontal)
                            .padding(.top, 5)
                    }
                    
                    Spacer(minLength: 10)
                    
                    VStack(spacing: 15) {
                        TextField("", text: $viewModel.name)
                            .placeholder(when: viewModel.name.isEmpty) {
                                Text("Name")
                                    .appFont(.funnelRegular, size: AppFontSize.placeholder)
                                    .foregroundColor(.gray)
                            }
                            .appFont(.funnelRegular, size: AppFontSize.placeholder)
                            // Remove vertical padding, apply calculated height
                            .padding(.horizontal) // Padding for text inside
                            .frame(height: textFieldHeight) // Set adaptive height
                            .background(Color.milkColor)
                            .cornerRadius(20)
                            .padding(.horizontal) // Padding for the field itself
                        
                        
                        TextField("", text: $viewModel.email)
                            .placeholder(when: viewModel.email.isEmpty) {
                                Text("Email")
                                    .appFont(.funnelRegular, size: AppFontSize.placeholder)
                                    .foregroundColor(.gray)
                            }
                            .appFont(.funnelRegular, size: AppFontSize.placeholder)
                            // Remove vertical padding, apply calculated height
                            .padding(.horizontal) // Padding for text inside
                            .frame(height: textFieldHeight) // Set adaptive height
                            .background(Color.milkColor)
                            .cornerRadius(20)
                            .padding(.horizontal) // Padding for the field itself
                            .keyboardType(.emailAddress)
                            .autocapitalization(.none)
                        
                        SecureField("", text: $viewModel.password)
                            .placeholder(when: viewModel.password.isEmpty) {
                                Text("Password")
                                    .appFont(.funnelRegular, size: AppFontSize.placeholder)
                                    .foregroundColor(.gray)
                            }
                            .appFont(.funnelRegular, size: AppFontSize.placeholder)
                            // Remove vertical padding, apply calculated height
                            .padding(.horizontal) // Padding for text inside
                            .frame(height: textFieldHeight) // Set adaptive height
                            .background(Color.milkColor)
                            .cornerRadius(20)
                            .padding(.horizontal) // Padding for the field itself
                        
                        SecureField("", text: $viewModel.confirmPassword)
                            .placeholder(when: viewModel.confirmPassword.isEmpty) {
                                Text("Confirm password")
                                    .appFont(.funnelRegular, size: AppFontSize.placeholder)
                                    .foregroundColor(.gray)
                            }
                            .appFont(.funnelRegular, size: AppFontSize.placeholder)
                            // Remove vertical padding, apply calculated height
                            .padding(.horizontal) // Padding for text inside
                            .frame(height: textFieldHeight) // Set adaptive height
                            .background(Color.milkColor)
                            .cornerRadius(20)
                            .padding(.horizontal) // Padding for the field itself
                            .padding(.bottom)
                    }
                    
                    Button {
                        viewModel.createAccountTapped()
                    } label: {
                        Image("createAnAccountMain")
                            .resizable()
                            .scaledToFit()
                            .frame(maxHeight: 65)
                            .padding(10)
                    }
                    .withDefaultShadow()
                    .disabled(viewModel.isLoading)
                    
                    Spacer(minLength: 10)
                    
                    VStack(spacing: 0) {
                        Button {
                            viewModel.logInTapped()
                        } label: {
                            Image("logIn")
                                .resizable()
                                .scaledToFit()
                                .frame(maxHeight: 65)
                                .padding(5)
                        }
                        .withDefaultShadow()
                        .disabled(viewModel.isLoading)
                        
                        Button {
                            viewModel.anonymousTapped()
                        } label: {
                            Image("anonimous")
                                .resizable()
                                .scaledToFit()
                                .frame(maxHeight: 65)
                                .padding(5)
                                .padding(.bottom, 40)
                        }
                        .withDefaultShadow()
                        .disabled(viewModel.isLoading)
                    }
                    .padding(.horizontal, 5)
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
            .frame(maxWidth: .infinity, maxHeight: .infinity)
        }
    }
}

struct RegistrationView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            RegistrationView(viewModel: RegistrationViewModel(coordinator: MainCoordinator()))
                .previewDevice("iPhone SE (3rd generation)")
                .previewDisplayName("iPhone SE")

            RegistrationView(viewModel: RegistrationViewModel(coordinator: MainCoordinator()))
                .previewDevice("iPhone 15 Pro Max")
                .previewDisplayName("iPhone 15 Pro Max")
        }
    }
}
