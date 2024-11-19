//
//  PlantRowBack.swift
//  BloomBuddy
//
//  Created by Simon Zwicker on 24.07.24.
//

import SwiftUI

struct PlantRowBack: View {
    @Environment(SensorManager.self) var sensorManager    
    let cardColor: Color
    let plant: Plant?
    let onDelete: () -> Void
    let onEdit: () -> Void
    let onWater: () -> Void

    var body: some View {
        VStack {
            Text(plant?.name ?? "")
                .foregroundStyle(.plantGreen)
                .font(.Bold.regularSmall)
                .lineLimit(1)
                .frame(maxWidth: .infinity)
                .padding(.top, 10)
            if plant?.sensor.isNotNil ?? false {
                if let sensor = sensorManager.sensordata?.first(where: {$0.id == plant?.sensor}) {
                    DataDisplay(sensor: sensor)
                } else {
                    DataDisplay()
                }
            }
           Text("Einstellungen")
                .foregroundStyle(.plantGreen)
                .font(.Bold.regularSmall)
                .lineLimit(1)
                .frame(maxWidth: .infinity)
            HStack {
                Image(systemName: "drop.transmission")
                    .symbolRenderingMode(.palette)
                    .font(.Regular.heading1)
                    .foregroundStyle(
                        .blue.opacity(0.6),
                        .plantGreen.opacity(0.7)
                    )
                    .frame(width: 30)
                Divider()
                    .frame(width: 2, height: 35.0)
                if let water = plant?.waterRequirement {
                    Text("\(water)%")
                        .foregroundStyle(.gray)
                        .font(.Bold.regularSmall)
                        .frame(maxWidth: .infinity)
                } else {
                    Text("–")
                        .foregroundStyle(.gray)
                        .font(.Bold.regularSmall)
                        .frame(maxWidth: .infinity)
                }
            }
            .padding(.horizontal, 10)
            if plant?.sensor.isNotNil ?? false, let sensor = sensorManager.sensordata?.first(where: {$0.id == plant?.sensor}) {
                HStack {
                    Image("SensorIcon")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 30)
                    Divider()
                        .frame(width: 2, height: 35.0)
                    Text("\(sensor.name)")
                        .foregroundStyle(.gray)
                        .font(.Bold.regularSmall)
                        .frame(maxWidth: .infinity)
                }
                .padding(.horizontal, 10)
            }
            Spacer()
            HStack {
                Image(systemName: "trash.circle.fill")
                    .symbolRenderingMode(.palette)
                    .font(.Regular.large)
                    .foregroundStyle(
                        .white.opacity(0.8),
                        .pink.opacity(0.6)
                    )
                    .button {
                        onDelete()
                    }
                
                Image(systemName: "pencil.circle.fill")
                    .symbolRenderingMode(.palette)
                    .font(.Regular.large)
                    .foregroundStyle(
                        .white.opacity(0.8),
                        .blue.opacity(0.4)
                    )
                    .button {
                        onEdit()
                    }
                    
                Image("wateringCan")
                    .symbolRenderingMode(.monochrome)
                    .resizable()
                    .scaledToFit()
                    .frame(width: 25, height: 25)
                    .foregroundStyle(.white.opacity(0.8))
                    .padding(7.5)
                    .background() {
                        Circle()
                            .fill(.plantGreen.opacity(0.6))
                    }
                    .frame(width: 46.5, height: 45.5)
                    .button {
                        onWater()
                    }
                
                
                
                

            }
            .padding(.bottom, 10)
            .padding(.horizontal, 10)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(cardColor.gradient.opacity(0.15))
        .clipShape(.rect(cornerRadius: 15.0))
    }
    
    struct DataDisplay: View {
        var sensor: Sensor? = nil
        var body: some View {
            HStack {
                if let sensor, sensor.model.hasBattery, let battery = sensor.battery {
                    battery.image
                        .symbolRenderingMode(.palette)
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .foregroundStyle(
                            .plantGreen.opacity(0.7),
                            .blue.opacity(0.6)
                        )
                        .frame(width: 30)
                    Divider()
                        .frame(width: 2, height: 35.0)
                    Text(battery.text)
                        .foregroundStyle(.gray)
                        .font(.Bold.regularSmall)
                        .frame(maxWidth: .infinity)
                } /*else {
                    Battery.mid.image
                        .symbolRenderingMode(.palette)
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .foregroundStyle(
                            .plantGreen.opacity(0.5),
                            .blue.opacity(0.4)
                        )
                        .frame(width: 40)
                        
                    Divider()
                        .frame(width: 2, height: 40.0)
                    VStack(alignment: .trailing) {
                        Text(Battery.mid.text)
                            .foregroundStyle(.gray)
                            .font(.Bold.regular)
                    }
                    .frame(maxWidth: .infinity)
                        
                }*/
            }
            .padding(.horizontal, 10)
        }
    }
}


#Preview {
    @Previewable var sensorManager = SensorManager()
    LazyVGrid(columns: [.init(), .init()],
              spacing: 10.0,
              content: {
        ZStack {
            PlantRow(cardColor: .green, plant: Plant(name: "Plume", size: 22, waterRequirement: 40, image: nil, sensor: UUID(uuidString: "1ae5a5b4-a6aa-4d76-8b72-40f660b35023")), resetFlip: .constant(false)) {
                print("delete")
            } onEdit: {
                print("edited")
            }
        
        }
        ZStack {
            PlantRow(cardColor: .yellow, plant: Plant(name: "Rose", size: 22, waterRequirement: 40, image: nil, sensor: nil), resetFlip: .constant(false)) {

            } onEdit: {

            }
        
        }
    })
    .padding()
    .environment(sensorManager)
}
