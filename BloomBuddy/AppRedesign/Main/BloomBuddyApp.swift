//
//  HackathonProject1App.swift
//  HackathonProject1
//
//  Created by Mia Koring on 14.07.24.
//

import SwiftUI

@main
struct BloomBuddyApp: App {
    @State private var locationManager: LocationManager = .init()

    var body: some Scene {
        WindowGroup {
            MainScreen()
                .environment(\.managedObjectContext, CoreDataProvider.shared.viewContext)
                .environment(locationManager)
        }
    }
}

