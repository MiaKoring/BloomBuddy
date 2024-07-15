//
//  PlantListView.swift
//  HackathonProject1
//
//  Created by Simon Zwicker on 14.07.24.
//

import SwiftUI

struct PlantListView: View {

    @Binding var plants: [Plant]
    private let adaptiveColumn = [
        GridItem(),
        GridItem()
    ]

    var body: some View {
        ScrollView {
            LazyVGrid(columns: adaptiveColumn, content: {
                ForEach(plants, id: \.id) { plant in
                    ZStack {
                        VStack {
                            Text(plant.name)
                                .font(.system(size: 22.0, weight: .bold))
                                .lineLimit(1)
                                .minimumScaleFactor(0.01)

                            Spacer()

                            VStack(alignment: .trailing) {
                                Text(plant.growthStage)
                                    .font(.system(size: 12.0, weight: .regular))
                                Text(plant.soilType)
                                    .font(.system(size: 10.0, weight: .regular))
                                Text(plant.waterRequirement)
                                    .font(.system(size: 10.0, weight: .regular))
                            }
                            .frame(maxWidth: .infinity, alignment: .trailing)
                        }

                        Image(plant.name)
                            .resizable()
                            .scaledToFit()
                            .frame(height: 100)
                            .offset(x: -40, y: 30)
                    }
                    .padding(15.0)
                    .frame(width: 150, height: 150)
                    .background(
                        RoundedRectangle(cornerRadius: 20.0)
                            .fill(gradient())
                    )
                }
            })
        }
    }

    private func gradient() -> LinearGradient {
        let random = [Gradient(colors: [.pink.opacity(0.0), .pink.opacity(0.44), .pink]),
         Gradient(colors: [.yellow.opacity(0.0), .yellow.opacity(0.44), .yellow]),
         Gradient(colors: [.green.opacity(0.0), .green.opacity(0.44), .green])
        ].randomElement()

        if let random {
            return LinearGradient(
                gradient: random,
                startPoint: .init(x: 0.50, y: 1.00),
                endPoint: .init(x: 0.50, y: 0.00)
            )
        } else {
            return LinearGradient(
                gradient: Gradient(colors: [.gray, .gray.opacity(0.44), .gray.opacity(0.0)]),
                startPoint: .init(x: 0.50, y: 1.00),
                endPoint: .init(x: 0.50, y: 0.00)
            )
        }
    }
}

#Preview {
    PlantListView(plants: .constant([Plant(id: "122312451", name: "Apfelbaum", soilType: "loamy", growthStage: "big", waterRequirement: "big")]))
}
