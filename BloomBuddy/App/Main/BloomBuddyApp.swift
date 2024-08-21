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

    var body: some Scene {
        WindowGroup {
            MainScreen()
                .modelContainer(for: PlantCollection.self)
                .environment(locationManager)
                .environment(sensorManager)
        }
    }
}

