//
//  WaterRequirement.swift
//  BloomBuddy
//
//  Created by Mia Koring on 17.07.24.
//

import SwiftUI

typealias WaterRequirement = WaterRequirementV2

enum WaterRequirementV1: String, CaseIterable {
    case small = "Wenig"
    case medium = "Mittel"
    case big = "Viel"
}

enum WaterRequirementV2: CaseIterable {
    typealias RawValue = String
    
    static var allCases: [WaterRequirement] {
        [
            .small, .medium, .big, .custom(0)
        ]
    }
    
    case small
    case medium
    case big
    case custom(Int)
}

extension WaterRequirement {
    var image: String { "drop.fill" }
    var color: Color { .blue.lighter() }
    
    init(percent: Int) {
        switch percent {
        case 20: self = .small
        case 50: self = .medium
        case 80: self = .big
        default: self = .custom(percent)
        }
    }
    
    var title: String {
        switch self {
        case .small: "Trocken"
        case .medium: "Feucht"
        case .big: "Nass"
        case .custom(let int): "Custom"
        }
    }
    
    var amount: Int {
        switch self {
        case .small: 1
        case .medium: 2
        case .big: 3
        case .custom(let percent):
            switch percent {
            case 0...30: 1
            case 31...60: 2
            default: 3
            }
        }
    }
    
    var percent: Int {
        switch self {
        case .small: 20
        case .medium: 50
        case .big: 80
        case .custom(let percent): percent
        }
    }

    func `is`(_ value: Self) -> Bool {
        self.percent == value.percent
    }

    func isNot(_ value: Self) -> Bool {
        self.percent != value.percent
    }
}
