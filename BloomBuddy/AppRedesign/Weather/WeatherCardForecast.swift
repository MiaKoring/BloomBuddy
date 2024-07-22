//
//  WeatherCardForecast.swift
//  BloomBuddy
//
//  Created by Simon Zwicker on 22.07.24.
//

import SwiftUI
import WeatherKit

struct WeatherCardForecast: View {

    // MARK: - Properties
    let forecast: [HourWeather]

    var body: some View {
        HStack {
            ForEach(forecast, id: \.date) { hour in
                VStack {
                    Image(systemName: hour.symbolName + ".fill")
                        .symbolRenderingMode(.multicolor)
                        .font(.Bold.small)
                        .padding(5.0)
                        .background(
                            Circle()
                                .fill(.plantGreen)
                        )
                    Text("\(hour.intTemp)°C")
                        .font(.Bold.small)
                    Text("\(hour.date.toString(with: "HH:mm"))")
                        .font(.system(size: 8.0, weight: .light))
                        .foregroundStyle(.gray)
                }
                .frame(maxWidth: .infinity)
            }
        }
        .padding(10.0)
        .background(.forecastBackground.opacity(0.9))
    }
}
