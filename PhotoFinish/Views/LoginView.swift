//
//  LoginView.swift
//  PhotoFinish
//
//  Created by Renata Liu on 2025-03-22.
//

import FirebaseCore
import SwiftUI

struct LoginView: View {
    
    @State var viewModel = LoginViewViewModel()
    
    var body: some View {
        NavigationView {
            VStack {
                // Header
                HeaderView(title: "PhotoFinish",
                           subtitle: "Get Things Done",
                           angle: 15,
                           background: Color.pink)
                
                // Login View
                Form {
                    TextField("Email Address", text: $viewModel.email)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .autocapitalization(.none)
                    SecureField("Password", text: $viewModel.password)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                    TLButton(title: "Log In", background: .blue) {
                        // Attempt login
                    }
                    .padding()
                }
                .offset(y: -50)
                
                VStack {
                    Text("New around here?")
                    NavigationLink("Create An Account", destination: RegisterView())
                }
                .padding(.bottom, 50)
                
                Spacer()
            }
            .padding()
        }
    }
}

#Preview {
    LoginView()
}
