//
//  photoUpload.swift
//  PhotoFinish
//
//  Created by Jasper Mao on 2025-03-22.
//

import SwiftUI
import FirebaseStorage
import FirebaseFirestore

struct PhotoUpload: View {
    // Use a constant for testing with a specific local image
    let testImage = UIImage(named: "exampleUpload")
    
    @State var retrievedImages = [UIImage]()
    
    var body: some View {
        VStack {
            // Display the test image
            if let image = testImage {
                Image(uiImage: image)
                    .resizable()
                    .scaledToFit()
                    .frame(height: 200)
            } else {
                Text("Test image not found")
                    .foregroundColor(.red)
            }
            
            Button {
                uploadPhoto()
            } label: {
                Text("Upload Photo")
            }
            .padding()
            .background(Color.blue)
            .foregroundColor(.white)
            .cornerRadius(8)
        }
        .padding()
        .onAppear {
            retrievePhotos()
        }
    }
    
    func uploadPhoto() {
        guard let selectedImage = testImage else {
            print("No test image available")
            return
        }
        
        // Create storage reference
        let storageRef = Storage.storage().reference()
        
        // Turn image into data
        guard let imageData = selectedImage.jpegData(compressionQuality: 0.8) else {
            print("Failed to convert image to data")
            return
        }
        
        // Specify filepath and name
        let path =  "images/\(UUID().uuidString).jpg"
        let fileRef = storageRef.child(path)
        
        // Upload data
        let uploadTask = fileRef.putData(imageData, metadata: nil) { metadata, error in
            if error == nil && metadata != nil {
                print("Successfully uploaded image")
                
                let db = Firestore.firestore()
                db.collection("images").document().setData(["url":path]) { error in
                    
                    //if no error, display new image
                    if error == nil {
                        DispatchQueue.main.async {
                            //add uploaded image to list of images for retired
                            self.retrievedImages.append(selectedImage)
                        }
                    }
                }
            } else {
                print("Error uploading: \(error?.localizedDescription ?? "unknown error")")
            }
        }
    }
    
    
    func retrievePhotos() {
        //get data from db
        let db = Firestore.firestore()
        
        db.collection("images").getDocuments { snapshot, error in
            
            if error == nil && snapshot != nil {
                
                var paths = [String]()
                
                for doc in snapshot!.documents {
                    // extract filepath
                    paths.append(doc["url"] as! String)
                }
                
                for path in paths {
                    // get reference to storage
                    let storageRef = Storage.storage().reference()
                    
                    //specify path
                    let fileRef = storageRef.child(path)
                    
                    //retrieve the data
                    fileRef.getData(maxSize: 5 * 1024 * 1024) { data, error in
                        
                        //check for errors
                        if error == nil && data != nil {
                            //create ui image and put into array for display
                            if let image = UIImage(data: data!) {
                                
                                DispatchQueue.main.async {
                                    retrievedImages.append(image)
                                }
                            }
                        }
                    }
                }
            }
        }
        
        //get image data in storage for each for each image reference
        
        //display images
    }
}

#Preview {
    PhotoUpload()
}
