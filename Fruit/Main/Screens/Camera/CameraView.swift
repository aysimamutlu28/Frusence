import SwiftUI
import AVFoundation
import UIKit

struct CameraView: View {
    @StateObject private var viewModel = CameraViewModel()
    @ObservedObject var ingredientsViewModel: IngredientsViewModel
    @Binding var showIngredients: Bool
    @Binding var selectedTab: TabItem
    @State private var isCameraTabActive: Bool = true
    
    var body: some View {
        ZStack {
            // Camera in the background
            CameraPreviewView(session: viewModel.session)
                .ignoresSafeArea()
                .opacity(viewModel.isSessionRunning ? 1 : 0)
            
            // If there is an error
            if let error = viewModel.error {
                Text(error.localizedDescription)
                    .foregroundColor(.white)
                    .padding()
                    .background(Color.black.opacity(0.7))
                    .cornerRadius(10)
            }
            
            // If fruits are recognized, we can add UI display
            if !viewModel.capturedFruits.isEmpty {
                VStack {
                    HStack {
                        Text("Recognized fruits: \(viewModel.capturedFruits.joined(separator: ", "))")
                            .foregroundColor(.white)
                            .padding()
                            .background(Color.black.opacity(0.5))
                            .cornerRadius(10)
                            .padding(.top, 40)
                        
                        Spacer()
                    }
                    
                    Spacer()
                }
                .padding(.horizontal)
            }
            
            // Photo capture button when camera tab is active
            if isCameraTabActive {
                VStack {
                    Spacer()
                    Button {
                        viewModel.capturePhoto()
                        print("Photo capture button pressed")
                        // After taking a photo, navigate to ingredients
                        withAnimation {
                            showIngredients = true
                        }
                    } label: {
                        Circle()
                            .stroke(Color.white, lineWidth: 3)
                            .frame(width: 70, height: 70)
                            .overlay(
                                Circle()
                                    .fill(Color.white)
                                    .frame(width: 60, height: 60)
                            )
                    }
                    .padding(.bottom, 180)
                    .withDefaultShadow()
                }
            }
            
            // Bottom navigation menu
            BottomNavigationBar(selectedTab: Binding(
                get: { selectedTab },
                set: { newTab in
                    if newTab != selectedTab {
                        if newTab == .savedRecipes {
                            // Create strong reference to viewModel
                            let vm = viewModel
                            // Stop session synchronously
                            vm.stopSession()
                            selectedTab = newTab
                            isCameraTabActive = false
                        } else {
                            selectedTab = newTab
                            isCameraTabActive = true
                            viewModel.startSession()
                        }
                    }
                }
            ))
        }
        .onAppear {
            isCameraTabActive = (selectedTab == .camera)
            if isCameraTabActive {
                viewModel.startSession()
            }
        }
    }
}

// UIViewRepresentable for camera integration with AVFoundation
struct CameraPreviewView: UIViewRepresentable {
    let session: AVCaptureSession
    
    class VideoPreviewView: UIView {
        override class var layerClass: AnyClass {
            return AVCaptureVideoPreviewLayer.self
        }
        
        var videoPreviewLayer: AVCaptureVideoPreviewLayer {
            return layer as! AVCaptureVideoPreviewLayer
        }
    }
    
    func makeUIView(context: Context) -> VideoPreviewView {
        let view = VideoPreviewView()
        view.backgroundColor = .black
        view.videoPreviewLayer.session = session
        view.videoPreviewLayer.videoGravity = .resizeAspectFill
        view.videoPreviewLayer.connection?.videoOrientation = .portrait
        return view
    }
    
    func updateUIView(_ uiView: VideoPreviewView, context: Context) {
        // Nothing needs to be updated since videoPreviewLayer automatically 
        // maintains connection with session and updates its size
    }
}

#Preview {
    let onboardingVM = OnboardingFormViewModel(coordinator: MainCoordinator())
    CameraView(
        ingredientsViewModel: IngredientsViewModel(onboardingSettings: onboardingVM),
        showIngredients: .constant(false),
        selectedTab: .constant(.camera)
    )
} 
