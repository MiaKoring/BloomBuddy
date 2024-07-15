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
            .mint.opacity(0),
            .mint.opacity(0.22),
            .mint.opacity(0.44),
            .mint
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
