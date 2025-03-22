//
//  HeaderView.swift
//  PhotoFinish
//
//  Created by Jonathan Cai on 2025-03-22.
//

import SwiftUI

struct HeaderView: View {
    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 0)
                .foregroundColor(Color.pink)
                .rotationEffect(Angle(degrees: 15))
            
            VStack {
                Text("PhotoFinish")
                    .font(.system(size: 50))
                    .foregroundColor(Color.white)
                    .bold()
                Text("Get Things Done")
                    .font(.system(size:30))
                    .foregroundColor(Color.white)
            }
            .padding(.top, 30)
        }
        .frame(width: UIScreen.main.bounds.width * 3, height: 300)
        .offset(y: -115)
    }
}

#Preview {
    HeaderView()
}
