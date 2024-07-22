//
//  HackathonProject1App.swift
//  HackathonProject1
//
//  Created by Mia Koring on 14.07.24.
//

import SwiftUI
import RealmSwift
import ZapdosKit
import CoreLocation

let waterCheckTaskId = "de.touchthegrass.BloomBuddy.checkWaterRequirement"

@main
struct HackathonProject1App: SwiftUI.App {
    @State var skipInit = UserDefaults().bool(forKey: "skipInit")
    @State private var locationManager: LocationManager = .init()
    @State private var zapdos: Zapdos = Zapdos()
    @State var showNotificationRequest: Bool = false
    @Environment(\.scenePhase) var phase
    
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
                
                if !skipInit {
                    InitializationView(skipInit: $skipInit)
                } else {
                    MainView()
                        .environment(locationManager)
                        .environment(zapdos)
                        .onAppear() {
                            showNotificationRequest = !UserDefaults.standard.bool(forKey: NotificationManager.allowedUDKey)
                        }
                        .alert("Möchtest du Benachrichtigungen erhalten?", isPresented: $showNotificationRequest) {
                            Button {
                                NotificationManager.requestAuth()
                            } label: {
                                Text("Ja")
                            }
                            Button(role: .cancel) {} label: {
                                Text("Nein")
                            }
                        }
                }
            }
        }
        .onChange(of: phase) {
            switch phase {
            case .background: BGTaskManager.scheduleWaterCheck()
            default: break
            }
        }
        .backgroundTask(.appRefresh(waterCheckTaskId)) {
            print("TaskCalled")
            NotificationManager.sendNotification("Alla gieß ma deine Pflanzen", description: "Die hamm ooch Jefühle")
            /*
            if await !zapdos.fetchWeather(for: CLLocation(latitude: 54.4858, longitude: 9.05239)) {
                print("Nope keen fetchn hier do")
                return
            }
            if UserDefaults.standard.integer(forKey: "lastWatered") > (Date().timeIntervalSinceReferenceDate - 3600).int {
                return
            }
            NotificationManager.sendNotification("Alla gieß ma deine Pflanzen", description: "Die hamm ooch Jefühle")*/
        }
    }
}
