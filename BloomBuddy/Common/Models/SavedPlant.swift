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
    @Persisted var growthStage: GrowthStage.RawValue
    @Persisted var waterRequirement: WaterRequirement.RawValue
    @Persisted(originProperty: "plants") var collections: LinkingObjects<Plants>
    
    convenience init(name: String, growthStage: GrowthStage, waterRequirement: WaterRequirement) {
        self.init()
        self.name = name
        self.growthStage = growthStage.rawValue
        self.waterRequirement = waterRequirement.rawValue
    }
}
