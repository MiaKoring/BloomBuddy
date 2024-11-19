//
//  Battery.swift
//  BloomBuddy
//
//  Created by Mia Koring on 19.11.24.
//
import SwiftUI

enum Battery: Int, Codable {
    case low = 1
    case mid = 2
    case high = 3
}

extension Battery {
    var image: Image {
        switch self {
        case .low:
            Image(systemName: "battery.25percent")
        case .mid:
            Image(systemName: "battery.50percent")
        case .high:
            Image(systemName: "battery.100percent")
        }
    }
    
    var text: String {
        switch self {
        case .low:
            "Niedrig"
        case .mid:
            "OK"
        case .high:
            "Voll"
        }
    }
}
