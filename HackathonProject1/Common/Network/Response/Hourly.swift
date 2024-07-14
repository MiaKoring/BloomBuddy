//
//  Hourly.swift
//  HackathonProject1
//
//  Created by Simon Zwicker on 14.07.24.
//

struct Hourly: Codable {
    let time: [String]
    let temperatures: [Double]

    enum CodingKeys: String, CodingKey {
        case time
        case temperatures = "temperature_2m"
    }
}
