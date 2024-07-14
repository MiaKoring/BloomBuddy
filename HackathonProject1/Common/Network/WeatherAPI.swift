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
            parameters["hourly"] = "temperature_2m"
            parameters["timezone"] = "auto"
        }
        return parameters
    }

    var encoding: Encoding {
        .url
    }
}
