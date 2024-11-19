//
//  PlantMigration.swift
//  BloomBuddy
//
//  Created by Mia Koring on 25.08.24.
//

import SwiftData

enum PlantMigrationPlan: SchemaMigrationPlan {
    static var schemas: [any VersionedSchema.Type] {
        [PlantSchemaV1.self, PlantSchemaV2.self, PlantSchemaV2_1.self]
    }
    
    static var stages: [MigrationStage] {
        [migrateV1toV2, migrateV2toV2_1]
    }
    
    static let migrateV2toV2_1 = MigrationStage.custom(
        fromVersion: PlantSchemaV2.self,
        toVersion: PlantSchemaV2_1.self,
        willMigrate: { context in
            let plants = try context.fetch(FetchDescriptor<PlantSchemaV2.Plant>())
            let new = {
                for plant in plants {
                    context.delete(plant)
                    context.insert(PlantSchemaV2_1.Plant(
                                    name: plant.name,
                                    size: plant.size,
                                    waterRequirement: plant.waterRequirement,
                                    image: plant.image,
                                    sensor: plant.sensor,
                                    lastWatered: 0.0  // Explicitly set default value
                                ))
                }
            }
        }, didMigrate: nil
    )
    
    static let migrateV1toV2 = MigrationStage.custom(
        fromVersion: PlantSchemaV1.self,
        toVersion: PlantSchemaV2.self,
        willMigrate: { context in
            let plants = try context.fetch(FetchDescriptor<PlantSchemaV1.Plant>())
            let new = {
                for plant in plants {
                    var water: WaterRequirementV2
                    switch WaterRequirementV1(rawValue: plant.waterRequirement) ?? .medium {
                    case .small: water = .small
                    case .medium: water = .medium
                    case .big: water = .big
                    }
                    context.delete(plant)
                    context.insert(PlantSchemaV2.Plant(name: plant.name, size: plant.size, waterRequirement: water.percent, image: plant.image, sensor: nil))
                }
            }
        }, didMigrate: nil
    )
}
