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
    @Persisted var growthStage: GrowthStage.RawValue
    @Persisted var waterRequirement: WaterRequirement.RawValue
    @Persisted(originProperty: "plants") var collections: LinkingObjects<PlantCollection>
    
    override init() {
        super.init()
    }
    
    init(name: String, size: Double, growthStage: GrowthStage = .medium, waterRequirement: WaterRequirement) {
        self.name = name
        self.size = size
        self.growthStage = growthStage.rawValue
        self.waterRequirement = waterRequirement.rawValue
    }
}
