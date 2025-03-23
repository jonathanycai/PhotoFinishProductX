//
//  DailyPhotoGalleryView.swift
//  PhotoFinish
//
//  Created by Renata Liu on 2025-03-23.
//

import SwiftUI
import FirebaseStorage
import Firebase

struct DailyPhotoGalleryView: View {
    let date: Date
    @State private var dayImages: [UIImage] = []
    
    private var formattedDay: String {
        let formatter = DateFormatter()
        formatter.dateFormat = "MMMM d"
        return formatter.string(from: date)
    }
    
    var body: some View {
        ZStack {
            Color.black
                .ignoresSafeArea()
            
            ScrollView {
                VStack {
                    Text(formattedDay)
                        .font(.largeTitle)
                        .fontWeight(.bold)
                        .foregroundStyle(
                            LinearGradient(
                                colors: [
                                    Color.blue,
                                    Color.cyan
                                ],
                                startPoint: .leading,
                                endPoint: .trailing
                            )
                        )
                    
                    Text("Daily tasks")
                        .foregroundColor(Color(.lightBlue))
                        .offset(y: -5)
                }
                
                MasonryView(images: dayImages)
                    .padding(16)
            }
            .onAppear {
                retrievePhotos()
            }
        }
    }
    
    func retrievePhotos() {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        let dayString = formatter.string(from: date)
        
        let db = Firestore.firestore()
        db.collection("images").getDocuments { snapshot, error in
            if let error = error {
                print("Error fetching documents: \(error)")
                return
            }
            
            guard let snapshot = snapshot else { return }
            
            var matchingPaths: [String] = []
            
            for doc in snapshot.documents {
                if let path = doc["url"] as? String {
                    let fileName = (path as NSString).lastPathComponent
                    if fileName.hasPrefix("\(dayString)_") {
                        matchingPaths.append(path)
                    }
                }
            }
            
            // Download images from the matching paths
            for path in matchingPaths {
                let storageRef = Storage.storage().reference().child(path)
                storageRef.getData(maxSize: 5 * 1024 * 1024) { data, error in
                    if let error = error {
                        print("Error downloading image: \(error)")
                        return
                    }
                    if let data = data, let image = UIImage(data: data) {
                        DispatchQueue.main.async {
                            self.dayImages.append(image)
                        }
                    }
                }
            }
        }
    }
}

#Preview {
    DailyPhotoGalleryView(date: Date())
}
