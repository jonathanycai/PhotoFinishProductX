//
//  User.swift
//  PhotoFinish
//
//  Created by Renata Liu on 2025-03-22.
//

import Foundation

struct User: Codable {
    let id: String
    let name: String
    let email: String
    let joined: TimeInterval
}
