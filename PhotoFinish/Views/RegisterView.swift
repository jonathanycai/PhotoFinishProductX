//
//  RegisterView.swift
//  PhotoFinish
//
//  Created by Jonathan Cai on 2025-03-22.
//

import SwiftUI

struct RegisterView: View {
    var body: some View {
        VStack {
            HeaderView(title: "Register",
                       subtitle: "Start Organizing",
                       angle: -15,
                       background: Color.orange)
            Spacer()
        }
    }
}

#Preview {
    RegisterView()
}
