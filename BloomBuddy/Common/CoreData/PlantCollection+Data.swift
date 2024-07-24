//
//  PlantCollection+Data.swift
//  BloomBuddy
//
//  Created by Simon Zwicker on 24.07.24.
//

import CoreData

extension PlantCollection {

    static var viewContext: NSManagedObjectContext {
        CoreDataProvider.shared.viewContext
    }

    // MARK: - Collection
    static var all: NSFetchRequest<PlantCollection> {
        let request = PlantCollection.fetchRequest()
        request.sortDescriptors = []
        return request
    }

    // MARK: - Plants
    var plantsEmpty: Bool {
        guard let plants else { return true }
        return plants.count == 0
    }

    var plantsRequest: NSFetchRequest<Plant> {
        let request = Plant.fetchRequest()
        request.sortDescriptors = []
        request.predicate = NSPredicate(format: "collection = %@", self)
        return request
    }
}
