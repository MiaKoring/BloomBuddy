//
//  Weather.swift
//  HackathonProject1
//
//  Created by Simon Zwicker on 14.07.24.
//

struct Weather: Codable {
    let latitude: Double
    let longitude: Double
    let hourly: Hourly
}
