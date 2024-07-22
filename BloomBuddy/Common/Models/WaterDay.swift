//
//  WaterDay.swift
//  BloomBuddy
//
//  Created by Mia Koring on 22.07.24.
//

import Foundation
import RealmSwift

final class WaterDay: Object, ObjectKeyIdentifiable {
    @Persisted(primaryKey: true) var _id: ObjectId
    @Persisted var date: Date
    @Persisted var rainAmount: Int
    @Persisted var shouldWater: Bool
    @Persisted var hasWatered: Bool
}
