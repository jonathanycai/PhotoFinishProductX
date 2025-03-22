//
//  CameraViewController.swift
//  PhotoFinish
//

import AVFoundation
import UIKit
import FirebaseStorage
import FirebaseFirestore

class ViewController: UIViewController {
    
    var retrievedImages = [UIImage]()
    var selectedImage: UIImage?

    
    
    // Capture Session
    var session: AVCaptureSession?
    
    // Photo Output
    let output = AVCapturePhotoOutput()
    
    // Video Preview
    let previewLayer = AVCaptureVideoPreviewLayer()
    
    // Shutter button
    private let shutterButton: UIButton = {
        let button = UIButton(frame: CGRect(x: 0, y: 0, width: 100, height: 100))
        button.layer.cornerRadius = 50
        button.layer.borderWidth = 10
        button.layer.borderColor = UIColor.white.cgColor
        return button
    }()
    
    // "PhotoFinish" title label
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.text = "PhotoFinish"
        label.font = UIFont.boldSystemFont(ofSize: 24)
        label.textColor = .white
        label.textAlignment = .center
        return label
    }()
    
    // Countdown label
    private let countdownLabel: UILabel = {
        let label = UILabel()
        label.text = "10"
        label.font = UIFont.boldSystemFont(ofSize: 20)
        label.textColor = .white
        label.textAlignment = .center
        return label
    }()
    
    // Countdown properties
    var countdownValue = 10
    var countdownTimer: Timer?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .black
        
        // Setup preview layer and UI elements
        view.layer.addSublayer(previewLayer)
        view.addSubview(shutterButton)
        view.addSubview(titleLabel)
        view.addSubview(countdownLabel)
        checkCameraPermissions()
        
        shutterButton.addTarget(self, action: #selector(didTapTakePhoto), for: .touchUpInside)
        
        // Start the 10-second countdown
        startCountdown()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        previewLayer.frame = view.bounds
        previewLayer.videoGravity = .resizeAspectFill
        
        // Position the shutter button at the bottom
        shutterButton.center = CGPoint(x: view.frame.size.width / 2,
                                       y: view.frame.size.height - 100)
        // Position the title label at the top
        titleLabel.frame = CGRect(x: 0, y: 50, width: view.bounds.width, height: 30)
        // Position the countdown label right below the title label
        countdownLabel.frame = CGRect(x: 0, y: titleLabel.frame.maxY + 10, width: view.bounds.width, height: 30)
    }
    
    private func checkCameraPermissions() {
        switch AVCaptureDevice.authorizationStatus(for: .video) {
        case .notDetermined:
            AVCaptureDevice.requestAccess(for: .video) { granted in
                guard granted else { return }
                DispatchQueue.main.async {
                    self.setUpCamera()
                }
            }
        case .restricted, .denied:
            // Handle restricted or denied access appropriately
            break
        case .authorized:
            setUpCamera()
        @unknown default:
            break
        }
    }
    
    private func setUpCamera() {
        let session = AVCaptureSession()
        if let device = AVCaptureDevice.default(for: .video) {
            do {
                let input = try AVCaptureDeviceInput(device: device)
                if session.canAddInput(input) {
                    session.addInput(input)
                }
                if session.canAddOutput(output) {
                    session.addOutput(output)
                }
                
                previewLayer.session = session
                previewLayer.videoGravity = .resizeAspectFill
                session.startRunning()
                self.session = session
            } catch {
                print("Error setting up camera: \(error)")
            }
        }
    }
    
    private func uploadPhoto() {
            // Make sure we have a selected image before proceeding
            guard let selectedImage = self.selectedImage,
                  let imageData = selectedImage.jpegData(compressionQuality: 0.8) else {
                print("Error: No image selected or failed to convert image to data")
                return
            }
            
            // Create storage reference
            let storageRef = Storage.storage().reference()
            
            // Specify filepath and name
            let path = "images/\(UUID().uuidString).jpg"
            let fileRef = storageRef.child(path)
            
            // Upload data
            _ = fileRef.putData(imageData, metadata: nil) { metadata, error in
                if error == nil && metadata != nil {
                    print("Successfully uploaded image")
                    
                    let db = Firestore.firestore()
                    db.collection("images").document().setData(["url": path]) { error in
                        
                        //if no error, handle success
                        if error == nil {
                            DispatchQueue.main.async {
                                // Add uploaded image to list of images
                                self.retrievedImages.append(selectedImage)
                                print("Image reference saved to Firestore")
                            }
                        } else {
                            print("Error saving to Firestore: \(error?.localizedDescription ?? "unknown error")")
                        }
                    }
                } else {
                    print("Error uploading: \(error?.localizedDescription ?? "unknown error")")
                }
            }
        }
    
    @objc private func didTapTakePhoto() {
        let settings = AVCapturePhotoSettings()
        settings.previewPhotoFormat = [kCVPixelBufferPixelFormatTypeKey as String: kCVPixelFormatType_32BGRA]
        settings.embeddedThumbnailPhotoFormat = [AVVideoCodecKey: AVVideoCodecType.jpeg.rawValue]
        output.capturePhoto(with: settings, delegate: self)
    }
    
    // Starts a 10-second countdown timer
    func startCountdown() {
        countdownValue = 10
        countdownLabel.text = "\(countdownValue)"
        countdownTimer = Timer.scheduledTimer(timeInterval: 1.0,
                                              target: self,
                                              selector: #selector(updateCountdown),
                                              userInfo: nil,
                                              repeats: true)
    }
    
    @objc func updateCountdown() {
        countdownValue -= 1
        countdownLabel.text = "\(countdownValue)"
        if countdownValue <= 0 {
            countdownTimer?.invalidate()
            countdownTimer = nil
            // Automatically take the photo when countdown finishes
            didTapTakePhoto()
        }
    }
    
    // Action for Complete Task button: Redirect to a different view
    @objc private func completeTaskButtonTapped() {
        
        if selectedImage == nil {
                print("No image to upload")
                // Maybe show an alert to the user
                return
            }
        
        uploadPhoto()
        // Create an instance of the new view controller
        let taskCompleteVC = TaskCompleteViewController()
        
        // If you're using a navigation controller, push the new view controller.
        if let navController = self.navigationController {
            navController.pushViewController(taskCompleteVC, animated: true)
        } else {
            // Otherwise, present it modally.
            taskCompleteVC.modalPresentationStyle = .fullScreen
            present(taskCompleteVC, animated: true, completion: nil)
        }
    }
}

extension ViewController: AVCapturePhotoCaptureDelegate {
    func photoOutput(_ output: AVCapturePhotoOutput,
                     didFinishProcessingPhoto photo: AVCapturePhoto,
                     error: Error?) {
        if let error = error {
            print("Error capturing photo: \(error)")
            return
        }
        
        guard let data = photo.fileDataRepresentation(),
              let image = UIImage(data: data) else { return }
        
        // Stop the capture session after the photo is taken
        session?.stopRunning()
        
        // Display the captured image
        let imageView = UIImageView(image: image)
        imageView.contentMode = .scaleAspectFill
        imageView.frame = view.bounds
        view.addSubview(imageView)
        self.selectedImage = image
        
        // Add the "Complete Task" button
        let completeTaskButton = UIButton(frame: CGRect(x: 50,
                                                        y: view.bounds.height - 100,
                                                        width: view.bounds.width - 100,
                                                        height: 50))
        completeTaskButton.setTitle("Complete Task", for: .normal)
        completeTaskButton.backgroundColor = .systemBlue
        completeTaskButton.layer.cornerRadius = 10
        completeTaskButton.addTarget(self, action: #selector(completeTaskButtonTapped), for: .touchUpInside)
        view.addSubview(completeTaskButton)
    }
}

// New view controller to display after the task is completed
class TaskCompleteViewController: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        
        // Simple label to indicate the new view
        let messageLabel = UILabel()
        messageLabel.text = "Task Complete!"
        messageLabel.font = UIFont.systemFont(ofSize: 24)
        messageLabel.textColor = .black
        messageLabel.textAlignment = .center
        messageLabel.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(messageLabel)
        
        NSLayoutConstraint.activate([
            messageLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            messageLabel.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
    }
}
