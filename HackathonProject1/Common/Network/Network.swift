//
//  Network.swift
//  HackathonProject1
//
//  Created by Simon Zwicker on 14.07.24.
//

import Foundation
import Mammut

struct Network {

    static private var environment: Environment = .weather
    static private var logLevel: Loglevel = .debugCurl

    static func request<T: Codable>(
        _ T: T.Type,
        environment: Environment,
        endpoint: Endpoint
    ) async throws -> T {
        self.environment = environment
        let result = await req(T.self, endpoint)
        switch result {
        case .success(let success): return success
        case .failure(let failure): throw failure.self
        }
    }

    static private func req<T: Codable>(_ T: T.Type, _ endpoint: Endpoint) async -> Result<T, Error> {
        let api = Mammut(components: environment.components, loglevel: logLevel)
        return await api.request(endpoint, error: ErrorObj.self)
    }
}
