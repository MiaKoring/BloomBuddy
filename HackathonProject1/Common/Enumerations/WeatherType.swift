//
//  WeatherType.swift
//  HackathonProject1
//
//  Created by Simon Zwicker on 14.07.24.
//

enum WeatherType: String, CaseIterable {
    case sunny = "sun.max.fill"
    case cloudySunny = "cloud.sun.fill"
    case cloudy = "cloud.fill"
    case rain = "cloud.rain.fill"
    case snow = "cloud.snow.fill"
    case thunderstorm = "cloud.bolt.rain"
    case windy = "wind"
}
