//
//  ContentView.swift
//  HackathonProject1
//
//  Created by Mia Koring on 14.07.24.
//

import SwiftUI
import CoreLocation

struct MainView: View {

    @Environment(LocationManager.self) private var locationManager
    @State private var plants: [Plant] = []
    @State private var weather: Weather?
    @State private var showInfo: Bool = false

    var body: some View {
        ZStack {
            VStack {
                WeatherCardView(weather: $weather)
                    .frame(alignment: .top)
                    .padding()
                    .shadow(radius: 10)

                PlantListView(plants: $plants)
            }

            tipButtonView
                .padding(.leading)
        }
        .sheet(isPresented: $showInfo, content: {
            TipsView()
                .presentationDetents([.medium])
        })
        .onChange(of: locationManager.location) { _, newValue in
            callAPIs(newValue)
        }
        .onAppear {
            locationManager.requestAuth()
            locationManager.requestLocation()
        }
    }

    @ViewBuilder
    private var tipButtonView: some View {
        VStack {
            Spacer()
            HStack {
                Image(systemName: "lightbulb")
                    .foregroundColor(.black.opacity(0.6))
                    .font(.system(size: 24))
                    .padding()
                    .background(
                        Circle().fill(.yellow.gradient)
                            .shadow(radius: 10)
                    )
                    .button {
                        showInfo.toggle()
                    }

                Spacer()
            }
        }
    }

    private func callAPIs(_ coords: CLLocationCoordinate2D?) {
        guard let coords else { return }
        Task {
            do {
                let plantsData = try await Network.request(
                    PocketBase<Plant>.self,
                    environment: .plants,
                    endpoint: PlantAPI.plants
                )

                let weatherData = try await Network.request(
                    Weather.self,
                    environment: .weather,
                    endpoint: WeatherAPI.forecast(coords.latitude, coords.longitude)
                )

                plants = plantsData.items
                weather = weatherData

                dump(weatherData)
                dump(plants)
            } catch {
                print("Error on retrieving Data: \(error.localizedDescription)")
            }
        }
    }
}
