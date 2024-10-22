//
//  ConfigStage.swift
//  BloomBuddy
//
//  Created by Mia Koring on 19.10.24.
//

enum ConfigStage: Int, CaseIterable {
    case instructions
    case wifi
    case air
    case water
}

extension ConfigStage {
    var next: ConfigStage {
        ConfigStage.allCases[self.rawValue + 1]
    }
    var previous: ConfigStage {
        ConfigStage.allCases[self.rawValue - 1]
    }
    
    var stringValue: String {
        switch self {
        case .instructions: return "Instructions"
        case .wifi: return "WiFi"
        case .air: return "air"
        case .water: return "water"
        }
    }
}
