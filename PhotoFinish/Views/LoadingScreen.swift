//
//  LoadingScreen.swift
//  PhotoFinish
//
//  Created by Renata Liu on 2025-03-23.
//

import SwiftUI

struct LoadingScreen: View {
    @State private var pulsate = false

    var body: some View {
        Text("Loading Memories...")
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
            .onAppear {
                withAnimation(
                    Animation.interpolatingSpring(stiffness: 100, damping: 5)
                        .repeatForever(autoreverses: true)
                ) {
                    pulsate = true
                }
            }
    }
}

#Preview {
    LoadingScreen()
}
