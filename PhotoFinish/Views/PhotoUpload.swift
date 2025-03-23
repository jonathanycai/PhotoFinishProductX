//
//  PhotoUpload.swift
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
    @State private var showingSheet = false

    var body: some View {
        VStack {
                

                Button {
                    uploadPhoto()
                } label: {
                    Text("Upload Photo")
                }
                .padding()
                .background(Color.blue)
                .foregroundColor(.white)
                .cornerRadius(8)
            
            Button("Show Sheet") {
                        showingSheet = true
                    }
                    .sheet(isPresented: $showingSheet) {
                        ContentView()
                    }

            /// Display retrieved images
            Text("Retrieved Images (\(retrievedImages.count))")
                .font(.headline)
                .padding(.top)

            ScrollView {
                LazyVGrid(columns: [
                    GridItem(.flexible(), spacing: 12),
                    GridItem(.flexible(), spacing: 12),
                    GridItem(.flexible(), spacing: 12)
                ], spacing: 12) { // Increased spacing between rows
                    ForEach(0..<retrievedImages.count, id: \.self) { index in
                        Image(uiImage: retrievedImages[index])
                            .resizable()
                            .scaledToFill()
                            .frame(width: 100, height: 100) // Fixed size with both width and height
                            .clipShape(RoundedRectangle(cornerRadius: 6))
                            .padding(4) // Added some padding around each image
                    }
                }
                .padding() // Added padding around the entire grid
            }
            }
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

        // Get current date and time
        let currentDate = Date()

        // Create date formatter
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd_HH-mm-ss"  // Using underscore and dashes instead

        // Format the date as a string
        let dateString = dateFormatter.string(from: currentDate)

        // Use the formatted date string in your file path
        let path = "images/\(dateString).jpg"
        
        let fileRef = storageRef.child(path)

        // Upload data
        _ = fileRef.putData(imageData, metadata: nil) { metadata, error in
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

                //loop through all returned docs
                for doc in snapshot!.documents {
                    // extract filepath
                    paths.append(doc["url"] as! String)
                }

                //loop through filepaths
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
                                    self.retrievedImages.append(image)
                                }
                            }
                        }
                    }
                }
            }
        }
    }
}

#Preview {
    PhotoUpload()
}
