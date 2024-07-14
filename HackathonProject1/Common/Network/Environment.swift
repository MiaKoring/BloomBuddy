//
//  Environment.swift
//  HackathonProject1
//
//  Created by Simon Zwicker on 14.07.24.
//

import Foundation

enum Environment {
    case weather
    case plants
}

extension Environment {
    var scheme: String {
        switch self {
        case .weather: "https"
        case .plants: "https"
        }
    }

    var host: String {
        switch self {
        case .weather: "api.open-meteo.com"
        case .plants: "kirreth.pockethost.io"
        }
    }

    var path: String {
        switch self {
        case .weather: "/v1"
        case .plants: "/api/collections"
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
