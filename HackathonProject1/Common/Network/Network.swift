//
//  Network.swift
//  HackathonProject1
//
//  Created by Simon Zwicker on 14.07.24.
//

import Foundation
import Mammut

struct Network {

    static private var weatherAPI: Mammut {
        Mammut(components: Environment.weather.components, loglevel: .debugCurl)
    }

    static private var plantsAPI: Mammut {
        Mammut(components: Environment.plants.components, loglevel: .debugCurl)
    }

    static func request<T: Codable>(
        _ T: T.Type,
        environment: Environment,
        endpoint: Endpoint
    ) async throws -> T {
        let result = await req(T.self, endpoint, environment )
        switch result {
        case .success(let success): return success
        case .failure(let failure): throw failure.self
        }
    }

    static private func req<T: Codable>(
        _ T: T.Type,
        _ endpoint: Endpoint,
        _ env: Environment
    ) async -> Result<T, Error> {
        switch env {
        case .weather:
            return await weatherAPI.request(endpoint, error: ErrorObj.self)
        case .plants:
            return await plantsAPI.request(endpoint, error: ErrorObj.self)
        }
    }
}
