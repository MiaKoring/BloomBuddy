//
//  SensorData.swift
//  BloomBuddy
//
//  Created by Mia Koring on 18.11.24.
//

import Foundation

struct SensorData: Codable {
    let id: UUID
    let name: String
    let sensor: Double?
    let battery: Int?
    let model: SensorModel
}

