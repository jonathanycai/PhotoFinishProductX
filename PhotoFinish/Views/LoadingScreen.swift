//
//  LoadingScreen.swift
//  PhotoFinish
//
//  Created by Renata Liu on 2025-03-23.
//

import SwiftUI

struct LoadingScreen: View {
    //dummy change
    @State private var pulsate = false

    var body: some View {
        Text("Loading Memories...")
            .font(.largeTitle)
            .fontWeight(.bold)
            .padding(.top, 40)
            .scaleEffect(pulsate ? 1.2 : 1.0)
            .overlay(
                LinearGradient(
                    gradient: Gradient(colors: [Color(.mainBlue), Color(.lightBlue)]),
                    startPoint: .leading,
                    endPoint: .trailing
                )
            )
            .mask(
                Text("Loading Memories...")
                    .font(.largeTitle)
                    .fontWeight(.bold)
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
