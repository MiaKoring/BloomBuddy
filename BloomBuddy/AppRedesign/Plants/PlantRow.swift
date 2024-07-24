//
//  PlantRow.swift
//  BloomBuddy
//
//  Created by Simon Zwicker on 22.07.24.
//

import SwiftUI

struct PlantRow: View {

    let cardColor: Color
    let plant: Plant?
    let onDelete: () -> Void

    var body: some View {
        VStack {
            Text(plant?.name ?? "")
                .foregroundStyle(.plantGreen)
                .font(.Bold.title)
                .lineLimit(2)

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
                .frame(maxWidth: /*@START_MENU_TOKEN@*/.infinity/*@END_MENU_TOKEN@*/)

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
                .frame(maxWidth: /*@START_MENU_TOKEN@*/.infinity/*@END_MENU_TOKEN@*/)

                Divider()
                    .frame(width: 1, height: 20.0)

                Image(systemName: "trash.circle.fill")
                    .symbolRenderingMode(.palette)
                    .font(.Regular.regular)
                    .foregroundStyle(
                        .plantGreen.darker().opacity(0.8),
                        .plantGreen.lighter().opacity(0.4)
                    )
                    .button {
                        onDelete()
                    }

            }
            .padding(.top, 5.0)
        }
        .padding()
        .background(cardColor.gradient.opacity(0.15))
        .clipShape(.rect(cornerRadius: 15.0))
    }
}
