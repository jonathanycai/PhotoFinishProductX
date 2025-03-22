//
//  CameraView.swift
//  PhotoFinish
//
//  Created by Renata Liu on 2025-03-22.
//

import SwiftUI

struct CameraView: UIViewControllerRepresentable {
    func makeUIViewController(context: Context) -> UIViewController {
            return ViewController()
        }

    func updateUIViewController(_ uiViewController: UIViewController, context: Context) {}
}

#Preview {
    ContentView()
}
