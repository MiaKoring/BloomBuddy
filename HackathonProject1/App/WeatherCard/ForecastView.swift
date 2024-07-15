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
                        .symbolRenderingMode(.multicolor)
                        .font(.title2)
                        .frame(height: 20)
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
