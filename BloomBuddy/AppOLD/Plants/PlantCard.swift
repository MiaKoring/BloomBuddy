//
//  PlantCard.swift
//  HackathonProject1
//
//  Created by Simon Zwicker on 15.07.24.
//

import SwiftUI
import RealmSwift

struct PlantCard: View {

    @ObservedRealmObject var plant: Plant
    @Binding var todaysRainMM: Double

    var body: some View {
        ZStack {
            VStack {
                Text(plant.name)
                    .font(.system(size: 22.0, weight: .bold))
                    .lineLimit(1)
                    .minimumScaleFactor(0.01)

                Spacer()

                VStack(alignment: .trailing) {
                    growthImage
                        .infoStyle()
                    wateringImage
                        .infoStyle()
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
                .fill(gradient(todaysRainMM, waterRequirement: plant.waterRequirement.rawValue))
        )
    }

    private func gradient(_ mm: Double, waterRequirement: String) -> LinearGradient {
        let red = Gradient(colors: [.pink.opacity(0.0), .pink.opacity(0.44), .pink])
        let yellow = Gradient(colors: [.yellow.opacity(0.0), .yellow.opacity(0.44), .yellow])
        let green = Gradient(colors: [.green.opacity(0.0), .green.opacity(0.44), .green])

        var gradient: Gradient = red

        if (waterRequirement == "small" && mm < 3) ||
            ((waterRequirement == "medium" || waterRequirement == "big") && (3...6).contains(mm)) {
            gradient = yellow
        } else if waterRequirement == "small" ||
                ((waterRequirement == "medium" || waterRequirement == "big") && mm > 6) {
            gradient = green
        }

        return LinearGradient(
                gradient: gradient,
                startPoint: .init(x: 0.50, y: 1.00),
                endPoint: .init(x: 0.50, y: 0.00)
            )
    }

    var wateringImage: Image {
        Image("watering\(plant.waterRequirement)")
    }
    
    var growthImage: Image {
        Image("Plant\(plant.growthStage)")
    }
}

extension Image {
    func infoStyle()-> some View {
        self
            .resizable()
            .renderingMode(.template)
            .foregroundStyle(.mint.darker())
            .scaledToFit()
            .frame(width: 25)
            .padding(8.0)
            .background(
                Circle()
                    .fill(.blue.lighter(by: 80))
            )
            .offset(x: 20, y: 20)
    }
}