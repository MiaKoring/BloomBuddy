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
    @Persisted var plants = RealmSwift.List<Plant>()
    
    override init() {
        super.init()
    }

    init(name: String) {
        self.name = name
    }
}
