//
//  SensorModel.swift
//  BloomBuddy
//
//  Created by Mia Koring on 18.11.24.
//

enum SensorModel: Int, Codable {
    case diy = 0
    case proV1 = 1
    case V1 = 2
}

extension SensorModel {
    var hasBattery: Bool {
        switch self {
        case .proV1:
            true
        default:
            false
        }
    }
}
