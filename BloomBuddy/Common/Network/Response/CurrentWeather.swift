//
//  CurrentWeather.swift
//  HackathonProject1
//
//  Created by Simon Zwicker on 15.07.24.
//

struct CurrentWeather: Codable {
    let time: String
    let interval, temperature2M, relativeHumidity2M, apparentTemperature: Double
    let isDay, precipitation, rain, showers: Double
    let snowfall, weatherCode, cloudCover: Double
    let pressureMsl, surfacePressure, windSpeed10M: Double
    let windDirection10M: Double
    let windGusts10M: Double

    enum CodingKeys: String, CodingKey {
        case time, interval
        case temperature2M = "temperature_2m"
        case relativeHumidity2M = "relative_humidity_2m"
        case apparentTemperature = "apparent_temperature"
        case isDay = "is_day"
        case precipitation, rain, showers, snowfall
        case weatherCode = "weather_code"
        case cloudCover = "cloud_cover"
        case pressureMsl = "pressure_msl"
        case surfacePressure = "surface_pressure"
        case windSpeed10M = "wind_speed_10m"
        case windDirection10M = "wind_direction_10m"
        case windGusts10M = "wind_gusts_10m"
    }
}
