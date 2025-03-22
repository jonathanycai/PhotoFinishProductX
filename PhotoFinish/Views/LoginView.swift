//
//  LoginView.swift
//  PhotoFinish
//
//  Created by Renata Liu on 2025-03-22.
//

import FirebaseCore
import SwiftUI

struct LoginView: View {
    
    @State var email = ""
    @State var password = ""
    
    var body: some View {
        NavigationView {
            VStack {
                // Header
                HeaderView()
                
                // Login View
                Form {
                    TextField("Email Address", text: $email)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                    SecureField("Email Address", text: $password)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                    Button {
                        // Attempt log in
                    } label: {
                        ZStack {
                            RoundedRectangle(cornerRadius: 10)
                                .foregroundColor(Color.blue)
                            
                            Text("Log in")
                                .foregroundColor(Color.white)
                                .bold()
                        }
                    }
                }
                
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
