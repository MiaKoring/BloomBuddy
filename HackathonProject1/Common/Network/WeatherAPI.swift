//
//  WeatherAPI.swift
//  HackathonProject1
//
//  Created by Simon Zwicker on 14.07.24.
//

import Foundation
import Mammut

enum WeatherAPI {
    case forecast(Double, Double)
}

extension WeatherAPI: Endpoint {

    var path: String {
        switch self {
        case .forecast: "/forecast"
        }
    }

    var method: MammutMethod {
        .get
    }

    var headers: [MammutHeader] {
        []
    }

    var parameters: [String : Any] {
        var parameters: [String: Any] = .init()
        switch self {
        case .forecast(let lat, let long):
            parameters["latitude"] = "\(lat)"
            parameters["longitude"] = "\(long)"
            parameters["hourly"] = "temperature_2m,relative_humidity_2m,precipitation_probability,precipitation,rain,showers,snowfall,weather_code,pressure_msl,surface_pressure,evapotranspiration,wind_speed_10m"
            parameters["timezone"] = "auto"
            parameters["current"] = "temperature_2m,relative_humidity_2m,apparent_temperature,is_day,precipitation,rain,showers,snowfall,weather_code,cloud_cover,pressure_msl,surface_pressure,wind_speed_10m,wind_direction_10m,wind_gusts_10m"
        }
        return parameters
    }

    var encoding: Encoding {
        .url
    }
}
