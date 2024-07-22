//
//  HackathonProject1App.swift
//  HackathonProject1
//
//  Created by Mia Koring on 14.07.24.
//

import SwiftUI
import RealmSwift

@main
struct HackathonProject1App: SwiftUI.App {
    @State private var locationManager: LocationManager = .init()

    var body: some Scene {
        WindowGroup {
            MainScreen()
                .environment(\.realmConfiguration, Realm.Configuration())
                .environment(locationManager)
        }
    }
}
