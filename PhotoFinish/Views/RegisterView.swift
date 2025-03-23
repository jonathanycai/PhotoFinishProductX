//
//  RegisterView.swift
//  PhotoFinish
//
//  Created by Jonathan Cai on 2025-03-22.
//

import SwiftUI

struct RegisterView: View {
    
    @StateObject var viewModel = RegisterViewViewModel()
    @State private var isPasswordVisible = false
    
    var body: some View {
        NavigationView {
            ZStack {
                Color.black
                    .ignoresSafeArea()
                
                VStack(spacing: 20) {
                    HeaderView()
                    
                    Text("Sign Up")
                        .font(.largeTitle)
                        .fontWeight(.bold)
                        .padding(.top, 40)
                        .overlay(
                            LinearGradient(
                                gradient: Gradient(colors: [Color(.mainBlue), Color(.lightBlue)]),
                                startPoint: .leading,
                                endPoint: .trailing
                            )
                        )
                        .mask(
                            Text("Sign Up")
                                .font(.largeTitle)
                                .fontWeight(.bold)
                        )
                    
                    // Form fields with the clean design
                    VStack(spacing: 16) {
                        TextField("Name", text: $viewModel.name)
                            .padding()
                            .background(Color.white.opacity(0.9))
                            .cornerRadius(20)
                            .autocapitalization(.none)
                        
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
                    
                    // Login button could go here
                    TLButton(title: "Sign Up", background: Color(.mainBlue)) {
                        viewModel.register()
                    }
                    .padding(.top, 30)
                    .padding(.horizontal, 20)
                    .frame(width: 200, height: 80)
                    
                    HStack {
                        Text("Already have an account?")
                            .foregroundColor(Color(.lightBlue))
                        NavigationLink("Log In", destination: LoginView())
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
    RegisterView()
}
