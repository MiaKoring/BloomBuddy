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

            PlantImage(120, "plantBg", color: .constant(cardColor), data: .constant(plant?.image), showButtons: .constant(false))
                .overlay(alignment: .bottomTrailing) {
                    if let plant, let sensorID = plant.sensor {
                        if let sensor = sensorManager.sensordata?.first(where: {$0.id == sensorID}), let updated = sensor.updated?.double, Date.now.timeIntervalSinceReferenceDate - updated >= 10800 || sensor.latest ?? 0 > 103 || sensor.latest ?? 0 < -3 {
                            Image(systemName: "exclamationmark.triangle.fill")
                                .symbolRenderingMode(.palette)
                                .foregroundStyle(.white, .orange)
                                .font(.title)
                                .onTapGesture {
                                    showHelp = true
                                }
                                .padding(5)
                        }
                    }
                }
            Text(plant?.name ?? "")
                .foregroundStyle(.plantGreen)
                .font(.Bold.regular)
                .lineLimit(1)
                .frame(maxWidth: .infinity)
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
            .padding(.horizontal, 10)
            .padding(.bottom, 10)
        }
        //.padding(10)
        .background(cardColor.gradient.opacity(0.15))
        .clipShape(.rect(cornerRadius: 15.0))
        .sheet(isPresented: $showHelp) {
            Text("Hilfe")
        }
    }
}

/*

#Preview {
    LazyVGrid(columns: [.init(), .init()],
              spacing: 10.0,
              content: {
            PlantRow(cardColor: .green, plant: Plant(name: "Plume", size: 22, waterRequirement: 40, image: nil, sensor: nil), resetFlip: .constant(false)) {
                print("edit")
            } onEdit: {
                print("edited")
            }
            .environment(SensorManager())
            PlantRow(cardColor: .yellow, plant: Plant(name: "Rose", size: 22, waterRequirement: 40, image: nil, sensor: nil), resetFlip: .constant(false)) {
                print("edit")
            } onEdit: {
                print("edited")
            }
            .environment(SensorManager())
    })
    .padding()
    
        
}
*/
#Preview {
    VStack {
        HStack(spacing: 20.0) {
            Text("Garten")
                .font(.Bold.title2)
            
            // TODO: - Next Feature, different PlantCollections
            //                Image(systemName: "chevron.down")
            //                    .font(.Bold.regular)
            Spacer()
            Image(systemName: "arrow.counterclockwise")
                .foregroundStyle(.plantGreen)
                .font(.Bold.title2)
                .button {
                    //refreshSensors()
                }
            Image(systemName: "gear")
                .foregroundStyle(.plantGreen)
                .font(.Bold.title2)
                .button {
                    //showSettings.setTrue()
                }
            Image(systemName: "plus")
                .foregroundStyle(.plantGreen)
                .font(.Bold.title2)
                .button {
                    //showAdd.setTrue()
                }
        }
        
        VStack(alignment: .leading) {
            Text("Bewässerung")
                .font(.Bold.verySmall)
                .foregroundStyle(.plantGreen)
            
            HStack {
                Text("keine")
                    .padding(.vertical, 5.0)
                    .frame(maxWidth: .infinity)
                    .background(
                        Color.plantGreen.opacity(0.15)
                    )
                    .clipShape(.rect(cornerRadius: 5.0))
                
                Text("möglich")
                    .padding(.vertical, 5.0)
                    .frame(maxWidth: .infinity)
                    .background(
                        Color.yellow.opacity(0.15)
                    )
                    .clipShape(.rect(cornerRadius: 5.0))
                
                Text("notwendig")
                    .padding(.vertical, 5.0)
                    .frame(maxWidth: .infinity)
                    .background(
                        Color.red.opacity(0.15)
                    )
                    .clipShape(.rect(cornerRadius: 5.0))
            }
            .font(.Bold.verySmall)
            .foregroundStyle(.gray)
        }
        .padding(.vertical, 10.0)
        
        PlantList([Plant(name: "abc", size: 12, waterRequirement: 40, image: nil, sensor: UUID()), Plant(name: "def", size: 12, waterRequirement: 40, image: nil, sensor: UUID())]) { plant in
            withAnimation {
                //collection.plants.removeAll(where: {$0.id == plant.id})
            }
        } onEdit: { plant in
            //editPlant = plant
        }
    }
    .environment(SensorManager())
    .padding(10)
}
