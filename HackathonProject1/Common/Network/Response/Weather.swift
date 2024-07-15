//
//  Weather.swift
//  HackathonProject1
//
//  Created by Simon Zwicker on 14.07.24.
//

struct Weather: Codable {
    let latitude, longitude, generationtimeMS: Double
    let utcOffsetSeconds: Int
    let timezone, timezoneAbbreviation: String
    let elevation: Int
    let current: CurrentWeather
    let hourly: Hourly

    enum CodingKeys: String, CodingKey {
        case latitude, longitude
        case generationtimeMS = "generationtime_ms"
        case utcOffsetSeconds = "utc_offset_seconds"
        case timezone
        case timezoneAbbreviation = "timezone_abbreviation"
        case elevation
        case current
        case hourly
    }
}

extension Weather: Equatable {
    static func == (lhs: Weather, rhs: Weather) -> Bool {
        (lhs.longitude == rhs.longitude) && (lhs.latitude == rhs.longitude)
    }
}
