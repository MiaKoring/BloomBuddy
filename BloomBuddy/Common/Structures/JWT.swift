//
//  JWT.swift
//  BloomBuddy
//
//  Created by Mia Koring on 19.10.24.
//

struct JWT: Codable {
    let subject: String
    let name: String
    let expiration: Double
}
