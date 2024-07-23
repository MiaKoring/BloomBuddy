//
//  ObservedPlant.swift
//  BloomBuddy
//
//  Created by Mia Koring on 17.07.24.
//

import RealmSwift

final class PlantCollection: Object, ObjectKeyIdentifiable {
    @Persisted(primaryKey: true) var _id: ObjectId
    @Persisted var name: String = ""
    @Persisted var plants: List<Plant> = .init()

    convenience init(name: String, plants: List<Plant> = .init()) {
        self.init()
        self.name = name
        self.plants = plants
    }
}
