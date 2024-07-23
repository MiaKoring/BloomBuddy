//
//  WaterRequirement.swift
//  BloomBuddy
//
//  Created by Mia Koring on 17.07.24.
//

import SwiftUI
import RealmSwift

enum WaterRequirement: String, CaseIterable, PersistableEnum {
    case small = "Wenig"
    case medium = "Mittel"
    case big = "Viel"
}

extension WaterRequirement {
    var image: String { "drop.fill" }
    var color: Color { .blue.lighter() }
    
    var amount: Int {
        switch self {
        case .small: 1
        case .medium: 2
        case .big: 3
        }
    }

    func `is`(_ value: Self) -> Bool {
        self == value
    }

    func isNot(_ value: Self) -> Bool {
        self != value
    }
}
