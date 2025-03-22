//
//  photoUpload.swift
//  PhotoFinish
//
//  Created by Jasper Mao on 2025-03-22.
//

import SwiftUI
import FirebaseStorage

struct PhotoUpload: View {
    var body: some View {
        VStack {
            
            Button {
                uploadPhoto()
            } label: {
                Text("Choose Photo")
            }
            
        }
        .padding()
    }
    
    func uploadPhoto() {
        // Create storage reference
        let storageRef = Storage.storage().reference()
        // Turn image into data
        
        //Upload data
        
        // Save referene to the file in Firestore DB
    }
    
}

#Preview {
    PhotoUpload()
}
