//
//  SavedPlants.swift
//  BloomBuddy
//
//  Created by Mia Koring on 17.07.24.
//

import RealmSwift

final class Plant: Object, ObjectKeyIdentifiable {
    @Persisted(primaryKey: true) var _id: ObjectId
    @Persisted var name: String
    @Persisted var size: Double
    @Persisted var growthStage: GrowthStage
    @Persisted var waterRequirement: WaterRequirement
    @Persisted(originProperty: "plants") var collections: LinkingObjects<PlantCollection>
    
    convenience init(
        name: String,
        size: Double,
        growthStage: GrowthStage = .small,
        waterRequirement: WaterRequirement = .small
    ) {
        self.init()
        self.name = name
        self.size = size
        self.growthStage = growthStage
        self.waterRequirement = waterRequirement
    }
}
