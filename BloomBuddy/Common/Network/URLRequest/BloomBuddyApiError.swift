//
//  BloomBuddyApiError.swift
//  BloomBuddy
//
//  Created by Mia Koring on 20.08.24.
//

import Foundation

enum BloomBuddyApiError: Error {
    case nameUsed
    case unauthorized
    case internalServer(String)
    case exceedingBasicSensorLimit
    case noSensorData
    case unknown(String)
}

extension BloomBuddyApiError: LocalizedError {
    static func byReason(_ reason: String) -> BloomBuddyApiError {
        switch reason {
        case "User with that name already exists": .nameUsed
        case "Error while hashing password": .internalServer(reason)
        case "fetching user failed": .internalServer(reason)
        case "Can't have more than 5 sensors": .exceedingBasicSensorLimit
        case "User has no ID": .internalServer(reason)
        case "Sensor has no ID": .internalServer(reason)
        case "No data available yet": .noSensorData
        case "user not found": .internalServer(reason)
        case "Unauthorized": .unauthorized
        default: .unknown(reason)
        }
    }
    
    var errorDescription: String? {
        switch self {
        case .nameUsed:
            NSLocalizedString("Nutzername wird bereits benutzt", comment: "Bitte nutze einen anderen")
        case .unauthorized:
            NSLocalizedString("Ungültige Anmeldedaten", comment: "")
        case .internalServer(let string):
            NSLocalizedString("Ein interner Serverfehler ist aufgetreten: \(string)", comment: "")
        case .exceedingBasicSensorLimit:
            NSLocalizedString("Du hast bereits 5/5 Sensoren erstellt", comment: "")
        case .noSensorData:
            NSLocalizedString("Der Sensor hat noch keine Daten gemeldet", comment: "")
        case .unknown(let string):
            NSLocalizedString("Ein interner Fehler ist aufgetreten: \(string)", comment: "")
        }
    }
}

extension BloomBuddyApiError: Identifiable {
    var id: String {
        "\(self.localizedDescription)"
    }
}
