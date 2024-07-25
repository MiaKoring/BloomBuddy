//
//  PlantCollection.swift
//  BloomBuddy
//
//  Created by Mia Koring on 25.07.24.
//

import Foundation
import SwiftData

@Model
final class PlantCollection {
    var id: UUID
    var name: String
    @Relationship(inverse: \Plant.collection)
    var plants: [Plant]
    
    init(id: UUID = UUID(), name: String, plants: [Plant] = []) {
        self.id = id
        self.name = name
        self.plants = plants
    }
}
