//
//  Hourly.swift
//  HackathonProject1
//
//  Created by Simon Zwicker on 14.07.24.
//

struct Hourly: Codable {
    let time: [String]
    let temperature2M: [Double]
    let relativeHumidity2M, precipitationProbability: [Double]
    let precipitation, rain, showers: [Double]
    let snowfall: [Double]
    let weatherCode: [Double]
    let pressureMsl, surfacePressure, evapotranspiration, windSpeed10M: [Double]

    enum CodingKeys: String, CodingKey {
        case time
        case temperature2M = "temperature_2m"
        case relativeHumidity2M = "relative_humidity_2m"
        case precipitationProbability = "precipitation_probability"
        case precipitation, rain, showers, snowfall
        case weatherCode = "weather_code"
        case pressureMsl = "pressure_msl"
        case surfacePressure = "surface_pressure"
        case evapotranspiration
        case windSpeed10M = "wind_speed_10m"
    }
}
