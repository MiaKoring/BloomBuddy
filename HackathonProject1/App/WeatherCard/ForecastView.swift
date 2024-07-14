//
//  ForecastView.swift
//  HackathonProject1
//
//  Created by Simon Zwicker on 14.07.24.
//

import SwiftUI

struct ForecastView: View {
    @Binding var data: [HourlyWeatherData]

    var body: some View {
        HStack {
            ForEach(data, id: \.id) { entry in
                VStack {
                    Image(systemName: entry.weather.rawValue)
                        .font(.title2)
                        .frame(height: 20) //damit die Temperaturen nicht bei unterschiedlich hohen images verschoben werden
                    Text("\(String(format: "%.1f", entry.temp)) °C")
                    Text("\(entry.hour):00")
                        .font(.caption2)
                        .foregroundStyle(.black.tertiary)
                }
                .frame(maxWidth: .infinity)
            }
        }
    }
}
