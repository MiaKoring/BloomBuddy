//
//  HourlyTemperature.swift
//  HackathonProject1
//
//  Created by Mia Koring on 14.07.24.
//

import Foundation

struct HourlyWeatherData {
    let id: UUID = .init()
    let hour: String
    let temp: Double
    let weather: WeatherType
}
