//
//  ForecastView.swift
//  HackathonProject1
//
//  Created by Simon Zwicker on 14.07.24.
//

import SwiftUI

struct ForecastView: View {
    var body: some View {
        HStack {
            ForEach(0..<5) { index in
                VStack {
                    Image(systemName: WeatherType.allCases.randomElement()?.rawValue ?? "")
                        .font(.title2)
                    Text("13.0 °C")
                    Text(Date.now.toString(with: "HH:mm"))
                        .font(.caption2)
                        .foregroundStyle(.black.tertiary)
                }
                .frame(maxWidth: .infinity)
            }
        }
    }
}
