//
//  SensorIdentifier.swift
//  BloomBuddy
//
//  Created by Mia Koring on 24.08.24.
//

import Foundation

struct SensorIdentifier: Codable, Identifiable {
    let id: UUID?
    let name: String
}
