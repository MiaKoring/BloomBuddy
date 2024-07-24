//
//  CoreDataProvider.swift
//  BloomBuddy
//
//  Created by Simon Zwicker on 24.07.24.
//

import CoreData

class CoreDataProvider {

    // MARK: - Properties
    static let shared: CoreDataProvider = .init()
    private let container: NSPersistentContainer

    private init() {
        container = .init(name: "PlantsCD")
        container.loadPersistentStores { description, error in
            if let error {
                fatalError("Unable to load CoreDataModel \(error)")
            }
        }
    }

    var viewContext: NSManagedObjectContext {
        container.viewContext
    }
}

// MARK: - Collections Data
extension CoreDataProvider {
    func createCollection(_ name: String) {
        do {
            let collection = PlantCollection(context: viewContext)
            collection.id = .init()
            collection.name = name
            collection.plants = .init()
            try viewContext.save()
        } catch {
            print("Error on create Collection: \(error.localizedDescription)")
        }
    }

    func deleteCollection(_ collection: PlantCollection) {
        viewContext.delete(collection)
        do {
            try viewContext.save()
        } catch {
            print("Error on Delete \(collection.name ?? "-"): \(error.localizedDescription)")
        }
    }
}

// MARK: - Plant Data
extension CoreDataProvider {
    func createPlant(
        _ name: String,
        size: Double,
        watering: WaterRequirement,
        collection: PlantCollection
    ) {
        do {
            let plant = Plant(context: viewContext)
            plant.id = .init()
            plant.name = name
            plant.size = size
            plant.waterRequirement = watering.rawValue
            collection.addToPlants(plant)
            try viewContext.save()
        } catch {
            print("Error on create Plant: \(error.localizedDescription)")
        }
    }

    func updatePlant(
        _ name: String,
        size: Double,
        watering: WaterRequirement,
        plant: Plant?
    ) {
        if plant == nil {
            return
        }
        plant?.name = name
        plant?.size = size
        plant?.waterRequirement = watering.rawValue

        do {
            try viewContext.save()
        } catch {
            print("Error on updating Plant \(error.localizedDescription)")
        }
    }

    func deletePlant(_ plant: Plant, collection: PlantCollection) {
        do {
            collection.removeFromPlants(plant)
            try viewContext.save()
        } catch {
            print("Error on Delete \(plant.name ?? "-") in \(plant.collection?.name ?? "-"): \(error.localizedDescription)")
        }
    }
}
