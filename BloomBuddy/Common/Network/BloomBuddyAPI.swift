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
    case info(String)
    case delete(String)
    case createSensor(String, String)
    case sensors(String)
    case sensorData(String, String)
    case allSensorData(String)
    case changeSensorName(String, String, String)
    case changeSensorModel(String, SensorModel, String)
    case registerDevice(String, String)
    case getDevices(String)
    case deleteDevice(String, String)
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
        case .changeSensorName(let id, _, _): "/users/sensors/\(id)"
        case .changeSensorModel(let id, _, _): "/users/sensorModel/\(id)"
        case .registerDevice, .getDevices: "/users/device"
        case .deleteDevice(let id, _): "/users/device/\(id)"
        }
    }

    var method: MammutMethod {
        switch self {
        case .login, .loginBasic, .createSensor, .createUser, .registerDevice: .post
        case .sensors, .sensorData, .allSensorData, .info, .getDevices: .get
        case .changeSensorName, .changeSensorModel: .patch
        case .delete, .deleteDevice: .delete
        }
    }

    var headers: [MammutHeader] {
        switch self {
        case .login(let username, let password): [ .authorization(.basic("\(username):\(password)")) ]
        case .loginBasic(let basic): [
            .authorization(.basic(basic)) ]
        case .createUser: []
        case .delete(let token), .info(let token), .createSensor(_, let token), .sensors(let token), .sensorData(_, let token), .allSensorData(let token), .changeSensorName(_, _, let token), .changeSensorModel(_, _, let token), .registerDevice(_, let token), .getDevices(let token), .deleteDevice(_, let token): [.authorization(.bearer(token))]
        }
    }
    
    var urlReqHeaders: [String: String] {
        switch self {
        case .createUser: [:]
        case .login(let username, let password): ["Authorization": "Basic \("\(username):\(password)".data(using: .utf8)?.base64EncodedString() ?? "")"]
        case .loginBasic(let basic): ["Authorization": "Basic \(basic)"]
        case .delete(let token), .info(let token), .createSensor(_, let token), .sensors(let token), .sensorData(_, let token), .allSensorData(let token), .changeSensorName(_, _, let token), .changeSensorModel(_, _, let token), .registerDevice(_, let token), .getDevices(let token), .deleteDevice(_, let token): ["Authorization": "Bearer \(token)"]
        }
    }

    var parameters: [String : Any] {
        switch self {
        case .createUser(let username, let password): ["name": username, "password": password]
        case .createSensor(let name, _), .changeSensorName(_, let name, _): ["name": name]
        case .registerDevice(let dt, _): ["dt": dt]
        case .changeSensorModel(_, let model, _): ["model": model]
        default: [:]
        }
    }

    var encoding: Encoding {
        .json
    }
}
