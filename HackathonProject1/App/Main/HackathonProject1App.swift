//
//  HackathonProject1App.swift
//  HackathonProject1
//
//  Created by Mia Koring on 14.07.24.
//

import SwiftUI

@main
struct HackathonProject1App: App {

    @State private var locationManager: LocationManager = .init()

    var body: some Scene {
        WindowGroup {
            MainView()
                .environment(locationManager)
        }
    }
}
