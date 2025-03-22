//
//  LoginViewViewModel.swift
//  PhotoFinish
//
//  Created by Jonathan Cai on 2025-03-22.
//

import Foundation

class LoginViewViewModel: ObservableObject{
    @Published var email = ""
    @Published var password = ""
    
    init() {}
    
    func login() {}
    
    func validate() {}
}
