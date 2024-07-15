//
//  WeatherType.swift
//  HackathonProject1
//
//  Created by Simon Zwicker on 14.07.24.
//

import SwiftUI

enum WeatherType: String, CaseIterable {
    case sunny = "sun.max.fill"
    case cloudySunny = "cloud.sun.fill"
    case cloudy = "cloud.fill"
    case rain = "cloud.rain.fill"
    case snow = "cloud.snow.fill"
    case thunderstorm = "cloud.bolt.rain"
    case windy = "wind"
}

extension WeatherType {
    var gradient: LinearGradient {
        switch self {
        case .sunny:
            LinearGradient(gradient: Gradient(colors: [Color("Sun"), Color.white, Color.white]), startPoint: .bottomLeading, endPoint: .topTrailing)

        case .cloudySunny:
            LinearGradient(gradient: Gradient(colors: [Color("Cloud1"), Color("Cloud2")]), startPoint: .bottomLeading, endPoint: .topTrailing)

        case .cloudy:
            LinearGradient(gradient: Gradient(colors: [Color("Cloud1"), Color("Cloud2")]), startPoint: .bottomLeading, endPoint: .topTrailing)

        case .rain:
            LinearGradient(gradient: Gradient(colors: [Color("Cloud1"), Color("Cloud2")]), startPoint: .bottomLeading, endPoint: .topTrailing)

        case .snow:
            LinearGradient(colors: [.white, .white, .gray], startPoint: .bottomLeading, endPoint: .topLeading)

        case .thunderstorm:
            LinearGradient(gradient: Gradient(colors: [Color("Cloud1"), Color("Cloud2")]), startPoint: .bottomLeading, endPoint: .topTrailing)

        case .windy:
            LinearGradient(colors: [.gray, .gray, .white], startPoint: .leading, endPoint: .trailing)
        }
    }
}
