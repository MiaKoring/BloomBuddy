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
    var body: some View {
        VStack {
            VStack(alignment: .leading) {
                Text("Test")
                    .padding(.bottom, 1)
                    .foregroundStyle(.black.secondary)
                Text("12.0 °C")
                    .font(.largeTitle)
                
                ForecastView()
            }
            .background(alignment: .topTrailing) {
                WeatherIconView()
                    .offset(x: 80, y: -80)
            }
        }
        .padding(20)
        .background {
            LinearGradient(gradient: Gradient(colors: [Color("Sun"), Color.white, Color.white]), startPoint: .bottomLeading, endPoint: .topTrailing)
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
