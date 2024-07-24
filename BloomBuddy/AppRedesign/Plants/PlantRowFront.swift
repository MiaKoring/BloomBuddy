//
//  PlantRowFront.swift
//  BloomBuddy
//
//  Created by Simon Zwicker on 24.07.24.
//

import SwiftUI

struct PlantRowFront: View {

    let cardColor: Color
    let plant: Plant?

    var body: some View {
        VStack {

            Text(plant?.name ?? "")
                .foregroundStyle(.plantGreen)
                .font(.Bold.regular)
                .lineLimit(2)
                .frame(maxWidth: .infinity)

            PlantImage(80, "plantBg", color: .constant(cardColor))

            HStack {
                VStack {
                    Image(systemName: "drop.fill")
                        .font(.Regular.regularSmall)
                        .foregroundStyle(.blue.lighter())
                        .frame(width: 20, height: 15)

                    Text(plant?.waterRequirement ?? "")
                        .foregroundStyle(.gray)
                        .font(.Bold.small)
                }
                .frame(maxWidth: .infinity)

                Divider()
                    .frame(width: 1, height: 20.0)

                VStack {
                    Image(systemName: "ruler")
                        .font(.Regular.regularSmall)
                        .foregroundStyle(.orange)
                        .frame(width: 20, height: 15)

                    Text("\(plant?.size.roundedInt ?? 0) cm")
                        .foregroundStyle(.gray)
                        .font(.Bold.small)
                }
                .frame(maxWidth: .infinity)
            }
            .padding(.top, 5.0)
        }
        .padding(10)
        .background(cardColor.gradient.opacity(0.15))
        .clipShape(.rect(cornerRadius: 15.0))
    }
}
