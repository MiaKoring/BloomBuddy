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
            if data.count >= 5 {
                ForEach(0..<5) { index in
                    VStack {
                        Image(systemName: data[index].weather.rawValue)
                            .font(.title2)
                            .frame(height: 20) //damit die Temperaturen nicht bei unterschiedlich hohen images verschoben werden
                        Text("\(String(format: "%.1f", data[index].temp)) °C")
                        Text("\(data[index].hour):00")
                            .font(.caption2)
                            .foregroundStyle(.black.tertiary)
                    }
                    if index < 4 {
                        Spacer() //DA LASSEN!!!
                    }
                }
            }
            else {
                ProgressView()
                    .progressViewStyle(.circular)
            }
        }
    }
}
