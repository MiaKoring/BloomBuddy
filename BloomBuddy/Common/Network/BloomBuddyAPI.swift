//
//  BloomBuddyApi.swift
//  BloomBuddy
//
//  Created by Mia Koring on 18.08.24.
//

import Foundation
import Mammut

enum BloomBuddyAPI {
    case createUser(String, String)
    case login(String, String)
    case loginBasic(String)
    case delete(String)
    case createSensor(String)
    case sensors(String)
    case sensorData(String, String)
    case allSensorData(String)
    case info(String)
}

extension BloomBuddyAPI: Endpoint, URLReqEndpoint {
    var path: String {
        switch self {
        case .createUser, .delete: "/users"
        case .login, .loginBasic: "/users/login"
        case .info: "/users/info"
        case .createSensor, .sensors: "/users/sensors"
        case .sensorData(let id, _): "/users/sensors/\(id)"
        case .allSensorData: "/users/sensors/all"
        }
    }

    var method: MammutMethod {
        switch self {
        case .login, .loginBasic, .createSensor, .createUser: .post
        case .sensors, .sensorData, .allSensorData, .info: .get
        case .delete: .delete
        }
    }

    var headers: [MammutHeader] {
        switch self {
        case .login(let username, let password): [ .authorization(.basic("\(username):\(password)")) ]
        case .loginBasic(let basic): [
            .authorization(.basic(basic)) ]
        case .createUser: []
        case .delete(let token), .info(let token), .createSensor(let token), .sensors(let token), .sensorData(_, let token), .allSensorData(let token): [.authorization(.bearer(token))]
        }
    }
    
    var urlReqHeaders: [String: String] {
        switch self {
        case .createUser: [:]
        case .login(let username, let password): ["Authorization": "Basic \("\(username):\(password)".data(using: .utf8)?.base64EncodedString() ?? "")"]
        case .loginBasic(let basic): ["Authorization": "Basic \(basic)"]
        case .delete(let token), .info(let token), .createSensor(let token), .sensors(let token), .sensorData(_, let token), .allSensorData(let token): ["Authorization": "Bearer \(token)"]
        }
    }

    var parameters: [String : Any] {
        switch self {
        case .createUser(let username, let password): ["name": username, "password": password]
        default: [:]
        }
    }

    var encoding: Encoding {
        .json
    }
}
