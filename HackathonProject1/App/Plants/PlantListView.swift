//
//  PlantListView.swift
//  HackathonProject1
//
//  Created by Simon Zwicker on 14.07.24.
//

import SwiftUI

struct PlantListView: View {

    @Binding var plants: [Plant]

    var body: some View {
        List {
            ForEach(plants, id: \.id) { plant in
                VStack(alignment: .leading) {
                    Text(plant.name)
                    Text(plant.growthStage)
                    Text(plant.soilType)
                    Text(plant.waterRequirement)
                }
                .padding(.vertical)
                .frame(alignment: .leading)
            }
        }
        .listStyle(.plain)
    }
}
