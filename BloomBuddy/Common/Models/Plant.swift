//
//  Plant.swift
//  HackathonProject1
//
//  Created by Simon Zwicker on 14.07.24.
//

struct Plant: Codable {
    let id: String
    let name: String
    let soilType: String
    let growthStage: String
    let waterRequirement: String

    enum CodingKeys: String, CodingKey {
        case id, name
        case soilType = "soil_type"
        case growthStage = "growth_stage"
        case waterRequirement = "water_requirement"
    }
}
