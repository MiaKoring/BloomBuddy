//
//  PlantRowFront.swift
//  BloomBuddy
//
//  Created by Simon Zwicker on 24.07.24.
//

import SwiftUI

struct PlantRowFront: View {
    @Environment(SensorManager.self) var sensorManager

    let cardColor: Color
    let plant: Plant?
    @State var showHelp = false

    var body: some View {
        VStack {

            Text(plant?.name ?? "")
                .foregroundStyle(.plantGreen)
                .font(.Bold.regular)
                .lineLimit(2)
                .frame(maxWidth: .infinity)

            PlantImage(80, "plantBg", color: .constant(cardColor), data: .constant(plant?.image), showButtons: .constant(false))
                .overlay(alignment: .bottomTrailing) {
                    if let plant, let sensorID = plant.sensor {
                        if let sensor = sensorManager.sensordata?.first(where: {$0.id == sensorID}), let updated = sensor.updated?.double, Date.now.timeIntervalSince1970 - updated >= 10800 {
                            Image(systemName: "exclamationmark.triangle.fill")
                                .symbolRenderingMode(.palette)
                                .foregroundStyle(.white, .orange)
                                .font(.title)
                                .offset(x: 15)
                                .onTapGesture {
                                    showHelp = true
                                }
                        }
                    }
                }

            HStack {
                VStack {
                    Image(systemName: "drop.fill")
                        .font(.Regular.regularSmall)
                        .foregroundStyle(.blue.lighter())
                        .frame(width: 20, height: 15)
                    
                    if let plant, let sensorID = plant.sensor {
                        if let sensorData = sensorManager.sensordata?.first(where: {$0.id == sensorID})?.latest {
                            Text("\(sensorData.int)%")
                                .foregroundStyle(.gray)
                                .font(.Bold.small)
                        } else {
                            Text("-")
                                .foregroundStyle(.gray)
                                .font(.Bold.small)
                        }
                    } else if let plant {
                        Text(WaterRequirement(percent: plant.waterRequirement).title)
                            .foregroundStyle(.gray)
                            .font(.Bold.small)
                    }
                }
                .frame(maxWidth: .infinity)

                Divider()
                    .frame(width: 1, height: 20.0)

                VStack {
                    if let plant, let sensorID = plant.sensor {
                        Image(systemName: "clock")
                            .font(.Regular.regularSmall)
                            .foregroundStyle(.orange)
                            .frame(width: 20, height: 15)
                        if let sensor = sensorManager.sensordata?.first(where: {$0.id == sensorID}), let updated = sensor.updated {
                            Text(Date.hmAgo(date: Date(timeIntervalSinceReferenceDate: updated.double)))
                                .foregroundStyle(.gray)
                                .font(.Bold.small)
                        } else {
                            Text("-")
                                .foregroundStyle(.gray)
                                .font(.Bold.small)
                        }
                    } else {
                        Image(systemName: "ruler")
                            .font(.Regular.regularSmall)
                            .foregroundStyle(.orange)
                            .frame(width: 20, height: 15)
                        
                        Text("\(plant?.size.roundedInt ?? 0) cm")
                            .foregroundStyle(.gray)
                            .font(.Bold.small)
                    }
                }
                .frame(maxWidth: .infinity)
            }
            .padding(.top, 5.0)
        }
        .padding(10)
        .background(cardColor.gradient.opacity(0.15))
        .clipShape(.rect(cornerRadius: 15.0))
        .sheet(isPresented: $showHelp) {
            Text("Hilfe")
        }
    }
}
