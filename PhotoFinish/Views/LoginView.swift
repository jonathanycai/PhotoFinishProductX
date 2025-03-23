//
//  LoginView.swift
//  PhotoFinish
//
//  Created by Renata Liu on 2025-03-22.
//

import FirebaseCore
import SwiftUI

struct LoginView: View {
    
    @StateObject var viewModel = LoginViewViewModel()
    @State private var isPasswordVisible = false
    
    var body: some View {
        NavigationView {
            ZStack {
                Color.black
                    .ignoresSafeArea()
                
                VStack(spacing: 20) {
                    HeaderView()
                    
                    Text("Log In")
                        .font(.largeTitle)
                        .fontWeight(.bold)
                        .padding(.top, 40)
                        .overlay(
                            LinearGradient(
                                gradient: Gradient(colors: [.mainBlue, .lightBlue]),
                                startPoint: .leading,
                                endPoint: .trailing
                            )
                        )
                        .mask(
                            Text("Log in")
                                .font(.largeTitle)
                                .fontWeight(.bold)
                        )
                    
                    // Form fields with the clean design
                    VStack(spacing: 16) {
                        // Email field
                        TextField("Email", text: $viewModel.email)
                            .padding()
                            .background(Color.white.opacity(0.9))
                            .cornerRadius(20)
                            .autocapitalization(.none)
                            .keyboardType(.emailAddress)
                        
                        // Password field with toggle
                        ZStack(alignment: .trailing) {
                            if isPasswordVisible {
                                TextField("Password", text: $viewModel.password)
                                    .padding()
                                    .background(Color.white.opacity(0.9))
                                    .cornerRadius(20)
                            } else {
                                SecureField("Password", text: $viewModel.password)
                                    .padding()
                                    .background(Color.white.opacity(0.9))
                                    .cornerRadius(20)
                            }
                            
                            Button(action: {
                                isPasswordVisible.toggle()
                            }) {
                                Image(systemName: isPasswordVisible ? "eye.slash" : "eye")
                                    .foregroundColor(.gray)
                            }
                            .padding(.trailing, 20)
                        }
                    }
                    .padding(.horizontal, 20)
                    
                    if !viewModel.errorMessage.isEmpty {
                        Text(viewModel.errorMessage)
                            .foregroundColor(.red)
                            .padding(.top, 10)
                    }
                    
                    // Login button could go here
                    TLButton(title: "Log In", background: Color(.mainBlue)) {
                        viewModel.login()
                    }
                    .padding(.top, 30)
                    .padding(.horizontal, 20)
                    .frame(width: 200, height: 80)
                    
                    HStack {
                        Text("New around here?")
                            .foregroundColor(Color(.lightBlue))
                        NavigationLink("Sign Up", destination: RegisterView())
                            .foregroundColor(Color(.mainBlue))
                    }
                    .padding(.top, 20)
                    
                    Spacer()
                }
            }
        }
        .navigationBarHidden(true)
        .navigationBarBackButtonHidden(true)
    }
}

#Preview {
    LoginView()
}
