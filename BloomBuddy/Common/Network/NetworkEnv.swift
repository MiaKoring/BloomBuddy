//
//  Environment.swift
//  HackathonProject1
//
//  Created by Simon Zwicker on 14.07.24.
//

import Foundation

enum NetworkEnv {
    case weather
}

extension NetworkEnv {
    var scheme: String {
        switch self {
        case .weather: "https"
        }
    }

    var host: String {
        switch self {
        case .weather: "api.open-meteo.com"
        }
    }

    var path: String {
        switch self {
        case .weather: "/v1"
        }
    }

    var components: URLComponents {
        var comp = URLComponents()
        comp.scheme = scheme
        comp.host = host
        comp.path = path
        return comp
    }
}
