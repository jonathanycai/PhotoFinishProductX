//
//  MainView.swift
//  PhotoFinish
//
//  Created by Jonathan Cai on 2025-03-22.
//

import FirebaseCore
import SwiftUI

struct MainView: View {
    init() {
        FirebaseApp.configure()
    }
    var body: some View {
        Text(/*@START_MENU_TOKEN@*/"Hello, World!"/*@END_MENU_TOKEN@*/)
    }
}

#Preview {
    MainView()
}
