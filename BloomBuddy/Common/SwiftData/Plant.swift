//
//  Plant.swift
//  BloomBuddy
//
//  Created by Mia Koring on 25.07.24.
//

import Foundation
import SwiftData

typealias Plant = PlantSchemaV2.Plant

enum PlantSchemaV2: VersionedSchema {
    static var versionIdentifier = Schema.Version(2, 0, 0)
    static var models: [any PersistentModel.Type] {
        [Plant.self]
    }
    
    @Model
    final class Plant {
        var id: UUID
        var name: String
        var size: Double
        var waterRequirement: Int
        var image: Data?
        var sensor: UUID?
        var collection: PlantCollection?
        
        init(id: UUID = UUID(), name: String, size: Double, waterRequirement: Int, image: Data?, sensor: UUID?) {
            self.id = id
            self.name = name
            self.size = size
            self.waterRequirement = waterRequirement
            self.image = image
            self.sensor = sensor
        }
        
    }
}

enum PlantSchemaV1: VersionedSchema {
    static var models: [any PersistentModel.Type] {
        [Plant.self]
    }
    
    static var versionIdentifier = Schema.Version(1, 0, 0)
    
    
    @Model
    final class Plant {
        var id: UUID
        var name: String
        var size: Double
        var waterRequirement: WaterRequirementV1.RawValue
        var image: Data?
        var sensor: UUID?
        var collection: PlantCollection?
        
        init(id: UUID = UUID(), name: String, size: Double, waterRequirement: WaterRequirementV1, image: Data?, sensor: UUID?) {
            self.id = id
            self.name = name
            self.size = size
            self.waterRequirement = waterRequirement.rawValue
            self.image = image
            self.sensor = sensor
        }
        
    }
}
