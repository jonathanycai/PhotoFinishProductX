//
//  HeaderView.swift
//  PhotoFinish
//
//  Created by Jonathan Cai on 2025-03-22.
//

import SwiftUI

struct HeaderView: View {
    let title: String
    let subtitle: String
    let angle: Double
    let background: Color
    
    var body: some View {
        VStack {
            Image("Logo")
                .padding(.top, 60)
            Text("PhotoFinish")
                .font(.title2)
                .fontWeight(.bold)
                .foregroundColor(.white)
        }
    }
}

#Preview {
    HeaderView(title: "Title",
               subtitle: "Subtitle",
               angle:15,
               background: .blue)
}
