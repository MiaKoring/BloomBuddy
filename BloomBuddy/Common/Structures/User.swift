//
//  User.swift
//  BloomBuddy
//
//  Created by Mia Koring on 22.11.24.
//
import Foundation

struct User: Codable {
    let id: UUID
    let name: String
    let password: String
}
