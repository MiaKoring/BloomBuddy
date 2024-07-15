//
//  ContentView.swift
//  HackathonProject1
//
//  Created by Mia Koring on 14.07.24.
//

import SwiftUI

struct MainView: View {

    @State private var plants: [Plant] = []
    @State private var weather: Weather?
    @State private var showInfo: Bool = false

    var body: some View {
        VStack {
            WeatherCardView(weather: $weather)
                .frame(alignment: .top)

            PlantListView(plants: $plants)
        }
        .sheet(isPresented: $showInfo, content: {
            TipsView()
                .presentationDetents([.medium])
        })
        .toolbar {
            ToolbarItem(placement: .bottomBar) {
                tipButtonView
            }
        }
        .task {
            do {
                let plantsData = try await Network.request(
                    PocketBase<Plant>.self,
                    environment: .plants,
                    endpoint: PlantAPI.plants
                )
                let weatherData = try await Network.request(Weather.self, environment: .weather, endpoint: WeatherAPI.forecast(48.8, 8.3333))

                plants = plantsData.items
                weather = weatherData

                dump(weatherData)
                dump(plants)
            } catch {
                print("Error on retrieving Data: \(error.localizedDescription)")
            }
        }
    }

    @ViewBuilder
    private var tipButtonView: some View {
        HStack {
            Image(systemName: "lightbulb")
                .foregroundColor(.black.opacity(0.6))
                .font(.system(size: 24))
                .padding()
                .background(
                    Circle().fill(.yellow.gradient)
                )
                .button {
                    showInfo.toggle()
                }

            Spacer()
        }
    }
}
