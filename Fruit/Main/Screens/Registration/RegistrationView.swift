import SwiftUI

struct RegistrationView: View {
    @StateObject var viewModel: RegistrationViewModel
    
    var body: some View {
        ZStack {
            VStack {
                Text("Registration")
                    .appFont(.funnelBold, size: AppFontSize.title)
                    .foregroundColor(.pinkColor)
                    .frame(maxWidth: .infinity, alignment: .center)
                    .padding(.top, 30)
                
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
                
                Spacer()
                
                VStack(spacing: 15) {
                    TextField("", text: $viewModel.name)
                        .placeholder(when: viewModel.name.isEmpty) {
                            Text("Name")
                                .appFont(.funnelRegular, size: AppFontSize.placeholder)
                                .foregroundColor(.gray)
                        }
                        .appFont(.funnelRegular, size: AppFontSize.placeholder)
                        .padding()
                        .background(Color.milkColor)
                        .cornerRadius(20)
                        .padding(.horizontal)
                    
                    
                        TextField("", text: $viewModel.email)
                            .placeholder(when: viewModel.email.isEmpty) {
                                Text("Email")
                                    .appFont(.funnelRegular, size: AppFontSize.placeholder)
                                    .foregroundColor(.gray)
                            }
                            .appFont(.funnelRegular, size: AppFontSize.placeholder)
                            .padding()
                            .background(Color.milkColor)
                            .cornerRadius(20)
                            .padding(.horizontal)
                            .keyboardType(.emailAddress)
                            .autocapitalization(.none)
                    
                    SecureField("", text: $viewModel.password)
                        .placeholder(when: viewModel.password.isEmpty) {
                            Text("Password")
                                .appFont(.funnelRegular, size: AppFontSize.placeholder)
                                .foregroundColor(.gray)
                        }
                        .appFont(.funnelRegular, size: AppFontSize.placeholder)
                        .padding()
                        .background(Color.milkColor)
                        .cornerRadius(20)
                        .padding(.horizontal)
                    
                    SecureField("", text: $viewModel.confirmPassword)
                        .placeholder(when: viewModel.confirmPassword.isEmpty) {
                            Text("Confirm password")
                                .appFont(.funnelRegular, size: AppFontSize.placeholder)
                                .foregroundColor(.gray)
                        }
                        .appFont(.funnelRegular, size: AppFontSize.placeholder)
                        .padding()
                        .background(Color.milkColor)
                        .cornerRadius(20)
                        .padding(.horizontal)
                        .padding(.bottom)
                }
                
                Button {
                    viewModel.createAccountTapped()
                } label: {
                    Image("createAnAccountMain")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .padding(10)
                }
                .withDefaultShadow()
                .disabled(viewModel.isLoading)
                
                Spacer()
                
                VStack(spacing: 0) {
                    Button {
                        viewModel.logInTapped()
                    } label: {
                        Image("logIn")
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
    }
}

struct RegistrationView_Previews: PreviewProvider {
    static var previews: some View {
        RegistrationView(viewModel: RegistrationViewModel(coordinator: MainCoordinator()))
    }
}
