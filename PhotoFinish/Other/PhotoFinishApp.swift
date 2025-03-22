//
//  PhotoFinishApp.swift
//  PhotoFinish
//
//  Created by Jonathan Cai on 2025-03-22.
//
import FirebaseCore
import SwiftUI
import Firebase

@main
struct PhotoFinishApp: App {
    init() {
        FirebaseApp.configure()
    }
    
    var body: some Scene {
        WindowGroup {
            MainView()
        }
    }
    
    init() {
        FirebaseApp.configure()
    }
}

#Preview {
    MainView()
}
