//
//  Plant.swift
//  BloomBuddy
//
//  Created by Mia Koring on 25.07.24.
//

import Foundation
import SwiftData

@Model
final class Plant {
    var id: UUID
    var name: String
    var size: Double
    var waterRequirement: WaterRequirement.RawValue
    var collection: PlantCollection?
    
    init(id: UUID = UUID(), name: String, size: Double, waterRequirement: WaterRequirement) {
        self.id = id
        self.name = name
        self.size = size
        self.waterRequirement = waterRequirement.rawValue
    }
    
}
