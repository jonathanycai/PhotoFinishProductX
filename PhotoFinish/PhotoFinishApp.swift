//
//  PhotoFinishApp.swift
//  PhotoFinish
//
//  Created by Jonathan Cai on 2025-03-22.
//

import SwiftUI
import Firebase

@main
struct PhotoFinishApp: App {
    var body: some Scene {
        WindowGroup {
            CameraView()
                .ignoresSafeArea()
        }
    }
    
    init() {
        FirebaseApp.configure()
    }
}
