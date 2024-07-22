//
//  ContentView.swift
//  HackathonProject1
//
//  Created by Mia Koring on 14.07.24.
//

import SwiftUI
import CoreLocation
import RealmSwift
import WeatherKit

struct MainView: View {
    @ObservedResults(Plant.self) private var plants
    @Environment(LocationManager.self) private var locationManager
    @State private var weather: Weather?
    @State private var showInfo: Bool = false

    var body: some View {
        ZStack {
            VStack {
                WeatherCardView(weather: $weather)
//                    .frame(alignment: .top)
                    .padding()

                if !plants.isEmpty {
                    HStack(spacing: 20.0) {
                        Text("nicht gießen")
                            .font(.system(size: 12.0, weight: .bold))
                            .padding(.vertical, 3.0)
                            .frame(maxWidth: .infinity)
                            .foregroundStyle(.green.lighter(by: 60.0))
                            .background(
                                RoundedRectangle(cornerRadius: 10.0)
                                    .fill(.green)
                            )


                        Text("gießen")
                            .font(.system(size: 12.0, weight: .bold))
                            .padding(.vertical, 3.0)
                            .frame(maxWidth: .infinity)
                            .foregroundStyle(.yellow.lighter(by: 60.0))
                            .background(
                                RoundedRectangle(cornerRadius: 10.0)
                                    .fill(.yellow)
                            )

                        Text("dringend gießen")
                            .font(.system(size: 12.0, weight: .bold))
                            .padding(.vertical, 3.0)
                            .frame(maxWidth: .infinity)
                            .foregroundStyle(.pink.lighter(by: 60.0))
                            .background(
                                RoundedRectangle(cornerRadius: 10.0)
                                    .fill(.pink)
                            )
                    }
                    .padding([.bottom, .leading, .trailing], 20.0)
                }

                PlantListView(plants: $plants, weather: $weather)
                    .shadow(radius: 10)
            }

            tipButtonView
                .padding(.leading)
        }
        .sheet(isPresented: $showInfo, content: {
            TipsView()
                .presentationDetents([.medium])
        })
        .onChange(of: locationManager.location, { _, newValue in
            
        })
        .onChange(of: locationManager.location, { _, newValue in
            callAPIs(newValue)
        })
        .onAppear {
            locationManager.requestAuth()
        }
    }

    @ViewBuilder
    private var tipButtonView: some View {
        VStack {
            Spacer()
            HStack {
                Image(systemName: "lightbulb")
                    .foregroundColor(.yellow.darker())
                    .font(.system(size: 24))
                    .padding()
                    .background(
                        Circle().fill(.yellow.lighter(by: 40).gradient)
                            .shadow(radius: 10.0)
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
//            do {
//                let weatherData = try await Network.request(
//                    Weather.self,
//                    environment: .weather,
//                    endpoint: WeatherAPI.forecast(coords.latitude, coords.longitude)
//                )
//                weather = weatherData
//
//                dump(weatherData)
//            } catch {
//                print("Error on retrieving Data: \(error.localizedDescription)")
//            }
        }
    }
}
