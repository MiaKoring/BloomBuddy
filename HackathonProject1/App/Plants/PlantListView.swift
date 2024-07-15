//
//  PlantListView.swift
//  HackathonProject1
//
//  Created by Simon Zwicker on 14.07.24.
//

import SwiftUI

struct PlantListView: View {

    @Binding var plants: [Plant]
    @Binding var weather: Weather?
    @State var todaysRainMM: Double = 0.0

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
                            .fill(gradient(todaysRainMM, waterRequirement: plant.waterRequirement))
                    )
                }
            })
        }
        .onChange(of: weather) {
            guard let weather = weather else { return }
            todaysRainMM = weather.hourly.rain.prefix(24).reduce(0.0, +)
        }
    }

    private func gradient(_ mm: Double, waterRequirement: String) -> LinearGradient {
        let red = Gradient(colors: [.pink.opacity(0.0), .pink.opacity(0.44), .pink])
        let yellow = Gradient(colors: [.yellow.opacity(0.0), .yellow.opacity(0.44), .yellow])
        let green = Gradient(colors: [.green.opacity(0.0), .green.opacity(0.44), .green])
        
        var gradient: Gradient
        
        if (waterRequirement == "small" && mm < 3) ||
            ((waterRequirement == "medium" || waterRequirement == "big") && (3...6).contains(mm)) {
            gradient = yellow
        } else if waterRequirement == "small" ||
                ((waterRequirement == "medium" || waterRequirement == "big") && mm > 6) {
            gradient = green
        }
        else {
            gradient = red
        }
        
        return LinearGradient(
                gradient: gradient,
                startPoint: .init(x: 0.50, y: 1.00),
                endPoint: .init(x: 0.50, y: 0.00)
            )
    }
}
