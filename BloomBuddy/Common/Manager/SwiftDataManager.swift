//
//  SwiftDataManager.swift
//  BloomBuddy
//
//  Created by Mia Koring on 18.11.24.
//

import Foundation
import SwiftData

struct SwiftDataManager {
    static func allPlants(withSensorId id: UUID) async throws -> [Plant] {
        let container = try ModelContainer(for: Plant.self)
        let context = ModelContext(container)
        
        let descriptor = FetchDescriptor(predicate: #Predicate<Plant> {$0.sensor == id})
        
        return try context.fetch(descriptor)
    }
}
