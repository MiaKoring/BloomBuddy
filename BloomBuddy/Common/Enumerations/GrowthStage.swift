//
//  GrowthStage.swift
//  BloomBuddy
//
//  Created by Mia Koring on 17.07.24.
//

import SwiftUI
import RealmSwift

enum GrowthStage: String, CaseIterable, PersistableEnum {
    case small = "Klein"
    case medium = "Mittel"
    case big = "Groß"
}

extension GrowthStage {
    var image: String { "ruler" }
    var color: Color { .orange }

    func `is`(_ value: Self) -> Bool {
        self == value
    }

    func isNot(_ value: Self) -> Bool {
        self != value
    }
}
