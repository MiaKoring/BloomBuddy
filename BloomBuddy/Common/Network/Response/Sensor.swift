//
//  Sensor.swift
//  BloomBuddy
//
//  Created by Mia Koring on 21.08.24.
//

import Foundation

struct Sensor: Codable {
    let id: UUID?
    let name: String
    let latest: Double?
    let battery: Battery?
    let model: SensorModel
    let updated: Int?
}
