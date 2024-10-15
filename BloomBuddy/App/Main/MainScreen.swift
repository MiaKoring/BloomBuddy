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
    @Environment(SensorManager.self) private var sensorManager
    
    @Query var collections: [PlantCollection]

    // MARK: - Properties
    @AppStorage(UDKey.tips.key) private var tips: Bool = false
    @AppStorage(UDKey.collection.key) private var collection: String = ""
    @State private var showTipDetail: Bool = false
    @State private var scrollPosition: CGPoint = .zero
    @State private var weather: Weather?
    @State var showLogin: Bool = false
    @State var unexpectedError: BloomBuddyApiError?

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
                        } refreshSensors: {
                            Task {
                                await fetchSensors()
                            }
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
        .task {
            await fetchSensors()
        }
        .alert(item: $unexpectedError) { error in
            Alert(title: Text("Ein unerwarteter Fehler ist aufgetreten"), message: Text(error.localizedDescription)) //TODO: Add error reporting to server
        }
        .sheet(isPresented: $showLogin) {
            LoginView() { dismiss in
                Task {
                    let res = await sensorManager.fetch()
                    switch res {
                    case .success:
                        break
                    case .failure(let failure):
                        unexpectedError = failure
                    }
                }
                dismiss()
            }
            .interactiveDismissDisabled()
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
    
    private func fetchSensors () async {
        if !UDKey.isSetup.boolValue {
            KeyChainManager.setValue(nil, for: .basicAuth)
            KeyChainManager.setValue(nil, for: .jwtAuth)
        }
        let res = await sensorManager.fetch()
        switch res {
        case .success:
            break
        case .failure(let failure):
            switch failure {
            case .unauthorized:
                showLogin = true
            default:
                unexpectedError = failure
            }
        }
    }
}
