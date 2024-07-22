//
//  ObservedPlant.swift
//  BloomBuddy
//
//  Created by Mia Koring on 17.07.24.
//

import RealmSwift

final class Plants: Object, ObjectKeyIdentifiable {
    @Persisted(primaryKey: true) var _id: ObjectId
    @Persisted var name: String = ""
    @Persisted var plants: List<Plant> = .init()
}
