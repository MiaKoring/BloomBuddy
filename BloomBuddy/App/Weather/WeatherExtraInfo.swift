//
//  WeatherExtraInfo.swift
//  BloomBuddy
//
//  Created by Simon Zwicker on 22.07.24.
//

import SwiftUI
import WeatherKit

struct WeatherExtraInfo: View {

    // MARK: - Properties
    let weather: Weather

    var body: some View {
        HStack {
            ZStack {
                VStack {
                    HStack(alignment: .bottom, spacing: 2.0) {
                        Text("\(weather.todaysSuntime ?? 0)")
                            .font(.Bold.title3)
                            .foregroundStyle(.plantGreen)
                        Text("h")
                            .foregroundStyle(.gray)
                            .font(.Bold.small)
                            .offset(y: -3)
                    }
                    Text("Sonne")
                        .font(.Regular.verySmall)
                        .foregroundStyle(.gray)
                }
            }
            .padding(.vertical)
            .padding(.horizontal, 10.0)
            .frame(maxWidth: .infinity)
            .background(
                RoundedRectangle(cornerRadius: 10.0)
                    .fill(.plantGreen.opacity(0.2))
            )

            ZStack {
                VStack {
                    HStack(alignment: .bottom, spacing: 2.0) {
                        Text("\(weather.precipitionAmount ?? 0)")
                            .font(.Bold.title3)
                            .foregroundStyle(.plantGreen)
                        Text("L/m²")
                            .foregroundStyle(.gray)
                            .font(.Bold.small)
                            .offset(y: -3)
                    }
                    Text("Regenmenge")
                        .font(.Regular.verySmall)
                        .foregroundStyle(.gray)
                        .lineLimit(1)
                }
            }
            .padding(.vertical)
            .padding(.horizontal, 10.0)
            .frame(maxWidth: .infinity)
            .background(
                RoundedRectangle(cornerRadius: 10.0)
                    .fill(.plantGreen.opacity(0.2))
            )

            ZStack {
                VStack {
                    HStack(alignment: .bottom, spacing: 2.0) {
                        Text("\(weather.intCurrentHumidity)")
                            .font(.Bold.title3)
                            .foregroundStyle(.plantGreen)
                        Text("%")
                            .foregroundStyle(.gray)
                            .font(.Bold.small)
                            .offset(y: -3)
                    }
                    Text("Feuchtigkeit")
                        .font(.Regular.verySmall)
                        .foregroundStyle(.gray)
                }
            }
            .padding(.vertical)
            .padding(.horizontal, 10.0)
            .frame(maxWidth: .infinity)
            .background(
                RoundedRectangle(cornerRadius: 10.0)
                    .fill(.plantGreen.opacity(0.2))
            )

            ZStack {
                VStack {
                    HStack(alignment: .bottom, spacing: 2.0) {
                        Text("\(weather.intCurrentWindspeed)")
                            .font(.Bold.title3)
                            .foregroundStyle(.plantGreen)
                        Text("km/h")
                            .foregroundStyle(.gray)
                            .font(.Bold.small)
                            .offset(y: -3)
                    }
                    Text("Wind")
                        .font(.Regular.verySmall)
                        .foregroundStyle(.gray)
                }
            }
            .padding(.vertical)
            .padding(.horizontal, 10.0)
            .frame(maxWidth: .infinity)
            .background(
                RoundedRectangle(cornerRadius: 10.0)
                    .fill(.plantGreen.opacity(0.2))
            )
        }
    }
}
