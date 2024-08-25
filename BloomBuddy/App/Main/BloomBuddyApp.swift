//
//  HackathonProject1App.swift
//  HackathonProject1
//
//  Created by Mia Koring on 14.07.24.
//

import SwiftUI
import SwiftData

@main
struct BloomBuddyApp: App {
    @State private var locationManager: LocationManager = .init()
    @State private var sensorManager: SensorManager = .init()
    let container: ModelContainer
    
    init() {
        do {
            container = try ModelContainer(
                for: Plant.self,
                migrationPlan: PlantMigrationPlan.self
            )
        } catch {
            fatalError("Failed to initialize model container.")
        }
    }

    var body: some Scene {
        WindowGroup {
            MainScreen()
                .modelContainer(for: PlantCollection.self)
                .modelContainer(container)
                .environment(locationManager)
                .environment(sensorManager)
        }
    }
}

