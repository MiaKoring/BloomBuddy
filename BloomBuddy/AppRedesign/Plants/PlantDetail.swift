//
//  PlantDetail.swift
//  BloomBuddy
//
//  Created by Simon Zwicker on 22.07.24.
//

import SwiftUI

struct PlantDetail: View {

    @State private var waterValue: Double = 0

    var body: some View {
        BackgroundView(.plantGreen.opacity(0.15)) {
            VStack(spacing: 25.0) {
                Text("Wasserbedarf")
                    .font(.Bold.regular)

                HStack {
                    ForEach(WaterRequirement.allCases, id: \.self) { water in
                        VStack(spacing: 5) {
                            HStack(spacing: 2) {
                                ForEach(0..<water.amount, id: \.self) { watering in
                                    Image(systemName: water.image)
                                        .font(.Regular.title)
                                }
                            }
                            .foregroundStyle(.blue.lighter())
                            .frame(maxWidth: .infinity)

                            Text(water.rawValue)
                                .font(.Bold.small)
                                .opacity(0.8)
                        }
                    }
                }
            }
            .padding()
        }
    }
}
