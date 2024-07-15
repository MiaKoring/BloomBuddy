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
    let gradient = LinearGradient(
        colors: [
            .blue.opacity(0),
            .blue.opacity(0.22),
            .blue.opacity(0.44),
            .blue
        ],
        startPoint: .init(x: 0.50, y: 1.00),
        endPoint: .init(x: 0.50, y: 0.00)
    )

    var body: some Scene {
        WindowGroup {
            ZStack {
                Color.clear.ignoresSafeArea().background(
                    gradient
                )

                MainView()
                    .environment(locationManager)
            }
        }
    }
}
