//
//  PlantAPI.swift
//  HackathonProject1
//
//  Created by Simon Zwicker on 14.07.24.
//

import Foundation
import Mammut

enum PlantAPI {
    case plants
}

extension PlantAPI: Endpoint {

    var path: String {
        switch self {
        case .plants: "/plants/records"
        }
    }

    var method: MammutMethod {
        .get
    }

    var headers: [MammutHeader] {
        []
    }

    var parameters: [String : Any] {
        [:]
    }

    var encoding: Encoding {
        .url
    }
}
