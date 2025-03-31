import SwiftUI

struct ProfileView: View {
    @StateObject var viewModel = ProfileViewModel()
    
    var body: some View {
        ZStack {
            // Background
            Image("background")
                .resizable()
                .aspectRatio(contentMode: .fill)
                .ignoresSafeArea(.all)
                
            VStack(spacing: 0) {
                // Header with close button
                HStack {
                    Text("Profile")
                        .appFont(.funnelBold, size: AppFontSize.title)
                        .foregroundColor(.milkColor)
                        .padding(.top, 50)
                    
                    Spacer()
                    
                    
                }
                .padding(.horizontal, 16)
                .padding(.top, 20)
                .padding(.bottom, 16)
                
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
                    } else {
                        // Content for non-logged in users
                        Text("You are not logged in")
                            .appFont(.clashDisplay, size: AppFontSize.motivation)
                            .foregroundColor(.milkColor)
                            .multilineTextAlignment(.center)
                            .frame(maxWidth: .infinity, alignment: .center)
                            .padding(.bottom, 200)
                            .padding(.horizontal, 5)
                        
                    }
                }
                .padding(.horizontal, 16)
                .padding(.bottom, 40)
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

struct ProfileView_Previews: PreviewProvider {
    static var previews: some View {
        ProfileView()
    }
} 
