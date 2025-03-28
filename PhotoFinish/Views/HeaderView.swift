//
//  HeaderView.swift
//  PhotoFinish
//
//  Created by Jonathan Cai on 2025-03-22.
//

import SwiftUI

struct HeaderView: View {
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
    HeaderView()
}
