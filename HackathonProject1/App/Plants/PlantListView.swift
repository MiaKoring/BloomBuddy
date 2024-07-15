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
        ScrollView(.horizontal) {
            LazyHStack(alignment: .center) {
                ForEach(plants, id: \.id) { plant in
                    VStack {
                        Text(plant.name)
                            .font(.largeTitle)
                        Text(plant.soilType)
                            .font(.caption)
                        Text(plant.waterRequirement)
                            .font(.caption)
                    }
                    .padding()
                    .frame(width: 250, height: 400)
                    .background(
                        RoundedRectangle(cornerRadius: 25.0)
                            .fill(.blue.gradient.opacity(0.8))
                    )
                }
            }
        }
        .scrollTargetBehavior(.paging)
    }
}
