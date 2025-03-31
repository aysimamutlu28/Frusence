import Foundation
import SwiftUI
import AVFoundation
import Combine
import Vision
import CoreML

class CameraViewModel: NSObject, ObservableObject {
    @Published var session = AVCaptureSession()
    @Published var isSessionRunning: Bool = false
    @Published var error: CameraError?
    @Published var capturedFruits: Set<String> = []
    
    private let sessionQueue = DispatchQueue(label: "sessionQueue")
    private var cancellables = Set<AnyCancellable>()
    private var photoOutput = AVCapturePhotoOutput()
    private var isProcessingPhoto = false
    private var isStoppingSession = false
    
    // Keep strong reference to self for asynchronous operations
    private var strongSelf: CameraViewModel?
    
    enum CameraError: Error, LocalizedError {
        case cameraUnavailable
        case cannotAddInput
        case cannotAddOutput
        case captureError
        case mlError
        
        var errorDescription: String? {
            switch self {
            case .cameraUnavailable:
                return "Camera unavailable"
            case .cannotAddInput:
                return "Failed to add input device"
            case .cannotAddOutput:
                return "Failed to add output device"
            case .captureError:
                return "Error capturing photo"
            case .mlError:
                return "Error recognizing fruits"
            }
        }
    }
    
    override init() {
        super.init()
        strongSelf = self
        checkPermissions()
    }
    
    private func checkPermissions() {
        switch AVCaptureDevice.authorizationStatus(for: .video) {
        case .authorized:
            self.setupSession()
        case .notDetermined:
            AVCaptureDevice.requestAccess(for: .video) { [weak self] granted in
                if granted {
                    DispatchQueue.main.async {
                        self?.setupSession()
                    }
                }
            }
        default:
            DispatchQueue.main.async {
                self.error = .cameraUnavailable
            }
        }
    }
    
    private func setupSession() {
        sessionQueue.async { [weak self] in
            guard let self = self else { return }
            
            self.session.beginConfiguration()
            
            // Quality settings
            if self.session.canSetSessionPreset(.photo) {
                self.session.sessionPreset = .photo
            }
            
            // Camera setup
            guard let videoDevice = AVCaptureDevice.default(.builtInWideAngleCamera, for: .video, position: .back) else {
                DispatchQueue.main.async {
                    self.error = .cameraUnavailable
                }
                self.session.commitConfiguration()
                return
            }
            
            do {
                let videoDeviceInput = try AVCaptureDeviceInput(device: videoDevice)
                
                guard self.session.canAddInput(videoDeviceInput) else {
                    DispatchQueue.main.async {
                        self.error = .cannotAddInput
                    }
                    self.session.commitConfiguration()
                    return
                }
                
                self.session.addInput(videoDeviceInput)
                
                // Add photo output
                guard self.session.canAddOutput(self.photoOutput) else {
                    DispatchQueue.main.async {
                        self.error = .cannotAddOutput
                    }
                    self.session.commitConfiguration()
                    return
                }
                
                self.session.addOutput(self.photoOutput)
                
                // Configuration completion
                self.session.commitConfiguration()
                
                // Start session
                self.startSession()
            } catch {
                DispatchQueue.main.async {
                    self.error = .cannotAddInput
                }
                self.session.commitConfiguration()
            }
        }
    }
    
    func startSession() {
        guard !isSessionRunning else { return }
        
        sessionQueue.async { [weak self] in
            guard let self = self else { return }
            
            if !self.session.isRunning {
                self.session.startRunning()
                DispatchQueue.main.async {
                    self.isSessionRunning = self.session.isRunning
                }
            }
        }
    }
    
    func stopSession() {
        guard isSessionRunning && !isStoppingSession else { return }
        isStoppingSession = true
        
        // Synchronously stop session
        if session.isRunning {
            session.stopRunning()
            isSessionRunning = false
            isStoppingSession = false
        }
        
        // Clear strong reference
        strongSelf = nil
    }
    
    // Method for capturing photo when camera button is pressed again
    func capturePhoto() {
        guard isSessionRunning, !isProcessingPhoto else {
            print("Failed to take photo: camera not running or another photo is being processed")
            return
        }
        
        print("Starting photo capture")
        isProcessingPhoto = true
        
        sessionQueue.async { [weak self] in
            guard let self = self else { return }
            
            print("Setting up photo in session queue")
            // Photo capture settings
            let photoSettings = AVCapturePhotoSettings()
            self.photoOutput.capturePhoto(with: photoSettings, delegate: self)
            print("Photo capture request sent")
        }
    }
    
    // Fruit recognition in image using ML model
    private func processFruitDetection(image: UIImage) {
        // Attempt to load ML model
        guard let mlModel = try? ml(configuration: MLModelConfiguration()).model,
              let visionModel = try? VNCoreMLModel(for: mlModel) else {
            DispatchQueue.main.async {
                self.error = .mlError
                self.isProcessingPhoto = false
            }
            print("Error: failed to load ML model")
            return
        }
        
        // Minimum confidence level (0.85 = 85%)
        let minimumConfidence: Float = 0.95
        
        // Create request for object recognition
        let request = VNCoreMLRequest(model: visionModel) { [weak self] request, error in
            guard let self = self, error == nil else {
                print("Recognition error: \(error?.localizedDescription ?? "unknown error")")
                DispatchQueue.main.async {
                    self?.error = .mlError
                    self?.isProcessingPhoto = false
                }
                return
            }
            
            // Process results
            guard let results = request.results as? [VNRecognizedObjectObservation] else {
                print("No recognition results")
                DispatchQueue.main.async {
                    self.isProcessingPhoto = false
                }
                return
            }
            
            // Filter results with high confidence
            let detectedFruits = results
                .filter { $0.confidence >= minimumConfidence }
                .compactMap { $0.labels.first?.identifier }
            
            DispatchQueue.main.async {
                // Add new fruits to the set
                detectedFruits.forEach { fruit in
                    self.capturedFruits.insert(fruit)
                    // Send notification about new fruit
                    FruitDetectionService.shared.notifyNewFruitDetected(fruit)
                }
                
                print("Recognized fruits: \(detectedFruits.joined(separator: ", "))")
                self.isProcessingPhoto = false
            }
        }
        
        // Configure image size and start analysis
        if let cgImage = image.cgImage {
            let handler = VNImageRequestHandler(cgImage: cgImage, options: [:])
            do {
                try handler.perform([request])
            } catch {
                print("Error executing Vision request: \(error.localizedDescription)")
                DispatchQueue.main.async {
                    self.error = .mlError
                    self.isProcessingPhoto = false
                }
            }
        } else {
            print("Failed to get CGImage from UIImage")
            DispatchQueue.main.async {
                self.error = .mlError
                self.isProcessingPhoto = false
            }
        }
    }
    
    deinit {
        print("CameraViewModel is being deinitialized")
        if isSessionRunning {
            stopSession()
        }
        cancellables.forEach { $0.cancel() }
    }
}

// Extension for handling photo capture results
extension CameraViewModel: AVCapturePhotoCaptureDelegate {
    func photoOutput(_ output: AVCapturePhotoOutput, didFinishProcessingPhoto photo: AVCapturePhoto, error: Error?) {
        print("Delegate received photoOutput call")
        
        if let error = error {
            print("Error processing photo: \(error.localizedDescription)")
            DispatchQueue.main.async {
                self.error = .captureError
                self.isProcessingPhoto = false
            }
            return
        }
        
        print("Photo successfully processed, preparing data")
        // Convert received data to UIImage
        guard let imageData = photo.fileDataRepresentation(),
              let image = UIImage(data: imageData) else {
            print("Failed to convert photo data to image")
            DispatchQueue.main.async {
                self.error = .captureError
                self.isProcessingPhoto = false
            }
            return
        }
        
        print("Sending image for recognition")
        // Send image for recognition
        processFruitDetection(image: image)
    }
} 
