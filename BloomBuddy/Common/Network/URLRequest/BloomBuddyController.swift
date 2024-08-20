//
//  BloomBuddyController.swift
//  BloomBuddy
//
//  Created by Mia Koring on 20.08.24.
//

import Foundation
import Mammut

struct BloomBuddyController {
    private static let host = "https://bloombuddy.touchthegrass.de"
    static func request(_ endpoint: URLReqEndpoint) async throws -> (Data, URLResponse) {
        guard let url = URL(string: "\(BloomBuddyController.host)\(endpoint.path)") else {
            throw NetworkError.invalidUrl
        }
        var req = URLRequest(url: url)
        req.httpMethod = endpoint.method.rawValue
        
        for header in endpoint.urlReqHeaders {
            req.setValue(header.value, forHTTPHeaderField: header.key)
        }
        
        req.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        guard let body: Data = {
            switch endpoint.encoding {
            case .json:
                try? JSONSerialization.data(withJSONObject: endpoint.parameters)
            default:
                try? JSONSerialization.data(withJSONObject: [])
            }
        }() else {
            throw NetworkError.jsonEncoding
        }
        req.httpBody = body
        
        return try await URLSession.shared.data(for: req)        
    }
    
    static func processResponse<T: Decodable>(_ data: Data, response res: URLResponse, expected: T.Type) -> Result<T, BloomBuddyApiError> {
        guard let res = res as? HTTPURLResponse else {
            return .failure(.unknown("ResponseDecode"))
        }
        if res.statusCode != 200 {
            guard let decoded = try? JSONDecoder().decode(ErrorResponse.self, from: data) else {
                return .failure(.unknown("JSONDecode"))
            }
            return .failure(.byReason(decoded.reason))
        } else {
            guard let decoded = try? JSONDecoder().decode(expected, from: data) else {
                return .failure(.unknown("JSONDecode"))
            }
            return .success(decoded)
        }
    }
}
