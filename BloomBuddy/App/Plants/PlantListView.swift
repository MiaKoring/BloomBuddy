//
//  PlantListView.swift
//  HackathonProject1
//
//  Created by Simon Zwicker on 14.07.24.
//

import SwiftUI
import RealmSwift

struct PlantListView: View {

    @ObservedResults(SavedPlant.self) var plants
    @Binding var weather: Weather?
    @State var todaysRainMM: Double = 0.0

    private let adaptiveColumn = [
        GridItem(),
        GridItem()
    ]

    var body: some View {
        ZStack {
            ScrollView {
                LazyVGrid(columns: adaptiveColumn, content: {
                    ForEach(plants, id: \.id) { plant in
                        PlantCard(plant: plant, todaysRainMM: $todaysRainMM)
                    }
                })
                .safeAreaInset(edge: .bottom, spacing: 0) {
                    Spacer().frame(height: 64)
                }
            }
            .onChange(of: weather) {
                print("WeatherUpdate PlantList")
                guard let weather = weather else { return }
                todaysRainMM = weather.hourly.rain.prefix(24).reduce(0.0, +)
            }

            if weather.isNil || plants.isEmpty {
                ProgressView("Loading")
            }
        }
    }
}