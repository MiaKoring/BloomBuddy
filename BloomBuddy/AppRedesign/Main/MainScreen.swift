//
//  MainScreen.swift
//  BloomBuddy
//
//  Created by Simon Zwicker on 22.07.24.
//

import SwiftUI
import ZapdosKit
import WeatherKit
import CoreLocation
import SwiftData

struct MainScreen: View {

    // MARK: - Environments
    @Environment(\.managedObjectContext) private var viewContext
    @Environment(LocationManager.self) private var locationManager
    @Environment(\.scenePhase) private var scenePhase
    @Environment(\.modelContext) var context
    
    @Query var collections: [PlantCollection]

    // MARK: - Properties
    @AppStorage(UDKey.tips.key) private var tips: Bool = false
    @AppStorage(UDKey.collection.key) private var collection: String = ""
    @State private var showTipDetail: Bool = false
    @State private var scrollPosition: CGPoint = .zero
    @State private var weather: Weather?

    var body: some View {
        BackgroundView(.plantGreen.opacity(0.15)) {
            ScrollView {
                VStack(spacing: 20) {
                    if let weather {
                        WeatherScreen(weather: weather)
                    } else {
                        ProgressView("Wetterdaten werden geladen...")
                            .padding(.vertical, 50.0)
                    }

                    if tips {
                        TipCard()
                    }

                    if !collections.isEmpty, let selected = collections.first(where: { $0.name == collection }) {
                        PlantsScreen(collection: selected) {
                            viewContext.refreshAllObjects()
                        }
                    }
                }
                .padding()
                .background(
                    GeometryReader { geometry in
                        Color.clear.preference(
                            key: ScrollOffsetKey.self,
                            value: geometry.frame(in: .named("mainScroll")).origin
                        )
                    }
                )
                .onPreferenceChange(ScrollOffsetKey.self, perform: { value in
                    self.scrollPosition = value
                })
            }
            .scrollIndicators(.hidden)
            .coordinateSpace(name: "mainScroll")
            if let weather {
                WeatherScrollHeader(scrollPosition: $scrollPosition, weather: weather)
            }
        }
        .onAppear {
            locationManager.requestAuth()
            checkCollections()
        }
        .onChange(of: scenePhase) { _, newPhase in
            guard newPhase == .active, let location = locationManager.location else { return }
            fetchWeather(.init(latitude: location.latitude, longitude: location.longitude))
        }
    }

    private func fetchWeather(_ location: CLLocation) {
        Task {
            _ = await Zapdos.shared.fetchWeather(for: location)
            self.weather = Zapdos.shared.weather
        }
    }

    private func checkCollections() {
        if collection.isEmpty {
            let defaultCollectionName = "Garten"
            context.insert(PlantCollection(name: defaultCollectionName))
            self.collection = defaultCollectionName
        }
    }
}
