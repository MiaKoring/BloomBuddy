//
//  BloomBuddyController.swift
//  BloomBuddy
//
//  Created by Mia Koring on 20.08.24.
//

import Foundation
import Mammut
import SwiftUI

typealias BBController = BloomBuddyController

struct BloomBuddyController {
    private static let host = "https://bloombuddy.touchthegrass.de"
    
    static func request<T: Decodable>(_ endpoint: BloomBuddyAPI, expected: T.Type) async -> Result<T, BloomBuddyApiError> {
        do {
            let (data, response) = try await req(endpoint)
            return processResponse(data, response: response, expected: expected)
        } catch {
            return .failure(.unknown(error.localizedDescription))
        }
    }
    
    static func handleUnauthorized(_ error: BloomBuddyApiError, showLogin: Binding<Bool>, unexpectedError: Binding<BloomBuddyApiError?>?) {
        switch error {
        case .unauthorized:
            showLogin.wrappedValue = true
        default:
            unexpectedError?.wrappedValue = error
        }
    }
    
    private static func req(_ endpoint: URLReqEndpoint) async throws -> (Data, URLResponse) {
        guard let url = URL(string: "\(BloomBuddyController.host)\(endpoint.path)") else {
            throw NetworkError.invalidUrl
        }
        var req = URLRequest(url: url)
        req.httpMethod = endpoint.method.rawValue
        
        for header in endpoint.urlReqHeaders {
            req.setValue(header.value, forHTTPHeaderField: header.key)
        }
        
        if endpoint.method != .get {
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
        }
        
        return try await URLSession.shared.data(for: req)        
    }
    
    private static func processResponse<T: Decodable>(_ data: Data, response res: URLResponse, expected: T.Type) -> Result<T, BloomBuddyApiError> {
        print(expected)
        guard let res = res as? HTTPURLResponse else {
            return .failure(.unknown("ResponseDecode"))
        }
        if res.statusCode != 200 {
            guard let decoded = try? JSONDecoder().decode(ErrorResponse.self, from: data) else {
                return .failure(.unknown("JSONDecode"))
            }
            return .failure(.byReason(decoded.reason))
        } else {
            if expected != String.self {
                guard let decoded = try? JSONDecoder().decode(expected, from: data) else {
                    return .failure(.unknown("JSONDecode"))
                }
                return .success(decoded)
            }
            guard let decoded = String(data: data, encoding: .utf8) as? T else {
                return .failure(.unknown("Response not utf-8 decodeable or convertible to T"))
            }
            return .success(decoded)
        }
    }
}
