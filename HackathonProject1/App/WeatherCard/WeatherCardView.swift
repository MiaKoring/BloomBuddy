//
//  WeatherCardView.swift
//  HackathonProject1
//
//  Created by Simon Zwicker on 14.07.24.
//

import SwiftUI
import Charts
import SwiftChameleon

struct WeatherCardView: View {

    @Binding var weather: Weather?

    var body: some View {
        ZStack {
            VStack(alignment: .leading, spacing: 25.0) {
                HStack {
                    VStack(alignment: .leading, spacing: 0) {
                        Text("Test")
                            .padding(.bottom, 1)
                            .foregroundStyle(.black.secondary)
                        Text("12.0 °C")
                            .font(.largeTitle)
                    }

                    Spacer()
                }

                ForecastView()
            }

            WeatherIconView()
                .offset(x: 180, y: -80)
        }
        .padding()
        .background {
            LinearGradient(
                gradient: Gradient(colors: [Color("Sun"), Color.white, Color.white]),
                startPoint: .bottomLeading,
                endPoint: .topTrailing
            )
        }
        .clipShape(RoundedRectangle(cornerRadius: 30))
        .task {
            do {
                let data = try await Network.request(Weather.self, environment: .weather, endpoint: WeatherAPI.forecast(48.8, 8.3333))
                print(data)
            } catch {
                print("Error \(error.localizedDescription)")
            }
        }
    }
}
