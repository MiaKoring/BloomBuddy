//
//  WeatherCard.swift
//  BloomBuddy
//
//  Created by Simon Zwicker on 22.07.24.
//

import SwiftUI
import WeatherKit

struct WeatherCard: View {

    // MARK: - Properties
    @Environment(LocationManager.self) private var locationManager
    let weather: Weather

    var body: some View {
        VStack {
            HStack {
                VStack(alignment: .leading, spacing: 0.0) {
                    Text("\(locationManager.country) - \(locationManager.city)")
                        .foregroundStyle(.white)
                        .font(.Bold.regularSmall)

                    HStack(alignment: .top, spacing: 0.0) {
                        Text("\(weather.currentTempCel.value.roundedInt)")
                            .font(.system(size: 68, weight: .bold))
                            .foregroundStyle(.white.opacity(0.9).gradient)

                        Text("°C")
                            .font(.Regular.heading1)
                            .padding(.top, 10.0)
                            .foregroundStyle(.white.opacity(0.9).gradient)
                    }

                    HStack {
                        HStack(spacing: 0) {
                            Image(systemName: "arrow.up")
                                .font(.Regular.verySmall)
                            Text("\(weather.extremes()?.1.value.roundedInt ?? 0)")
                                .font(.Bold.small)
                            Text("°C")
                                .font(.Regular.small)
                        }

                        HStack(spacing: 0) {
                            Image(systemName: "arrow.down")
                                .font(.Regular.verySmall)
                            Text("\(weather.extremes()?.0.value.roundedInt ?? 0)")
                                .font(.Bold.small)
                            Text("°C")
                                .font(.Regular.small)
                        }
                    }
                    .foregroundStyle(.white.opacity(0.9).gradient)
                }
                .padding(.top)

                Spacer()

                Image(systemName: weather.currentWeather.symbolName + ".fill")
                    .symbolRenderingMode(.multicolor)
                    .font(.system(size: 68))
            }
            .padding(.horizontal)

            WeatherCardForecast(forecast: weather.nextHourlyForecasts(count: 5))
                .padding(.top)
        }
        .frame(maxWidth: .infinity)
        .background(
            Image("plantBg")
                .resizable()
                .scaledToFill()
                .opacity(0.8)
                .overlay {
                    Color.plantGreen.opacity(0.6)
                }
        )
        .clipShape(.rect(cornerRadius: 20.0))
    }
}
