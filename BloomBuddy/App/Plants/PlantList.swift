//
//  PlantList.swift
//  BloomBuddy
//
//  Created by Simon Zwicker on 23.07.24.
//

import SwiftUI
import CoreData
import ZapdosKit

struct PlantList: View {

    // MARK: - Properties
    var plants: [Plant]
    let onDelete: (Plant) -> Void
    let onEdit: (Plant) -> Void
    @State var resetFlip: Bool = false
    @Environment(SensorManager.self) var sensorManager
    
    init(_ plants: [Plant], onDelete: @escaping (Plant) -> Void, onEdit: @escaping (Plant) -> Void) {
        self.plants = plants
        self.onDelete = onDelete
        self.onEdit = onEdit
    }

    var body: some View {
        if plants.isEmpty {
            ContentUnavailableView(
                "Pflanzen anlegen",
                systemImage: "leaf",
                description: Text("Drücke auf das Plus um Pflanzen aus deinem Garten anzulegen.")
            )
        } else {
            LazyVGrid(columns: [.init(), .init()],
                      spacing: 10.0,
                      content: {
                ForEach(plants, id: \.id) { plant in
                    PlantRow(
                        cardColor: calcWatering(for: plant),
                        plant: plant,
                        resetFlip: $resetFlip,
                        onDelete: {
                            onDelete(plant)
                        },
                        onEdit: {
                            onEdit(plant)
                        }
                    )
                }
            })
        }
    }
    
    func calcWatering(for plant: Plant) -> Color {
        let currentTime = Date().timeIntervalSinceReferenceDate
        let lastWatered = plant.lastWatered ?? 0
        
        let diff = currentTime - lastWatered
        
        if let sensorID = plant.sensor {
            guard let double = sensorManager.sensordata?.first(where: {$0.id == sensorID})?.latest else {
                return .gray
            }
            if diff <= 7200 {
                return.green
            }
            if Int(double) <= plant.waterRequirement - 20 { return .red }
            if ((plant.waterRequirement - 19)...(plant.waterRequirement - 10)).contains(Int(double)) { return .yellow }
            return .green
        }
        guard let weather = Zapdos.shared.weather else {
            return .gray
        }
        
        guard let precipation = weather.precipitionAmount?.double else {
            return .gray
        }
        
        let wateringCompensation = diff < 3600 * 24 ? 0.5: diff < 3600 * 48 ? 0.75: 1
        
        let required = plant.size * 0.25 * wateringCompensation
        
        if precipation >= (required / 100) * 95 { return .green }
        if precipation >= (required / 100) * 70 { return .yellow }
        return .red
    }
}

#Preview {
    @Previewable var plants = [Plant(name: "abc", size: 12, waterRequirement: 40, image: nil, sensor: UUID()), Plant(name: "def", size: 12, waterRequirement: 40, image: nil, sensor: UUID())]
    LazyVGrid(columns: [.init(), .init()],
              spacing: 10.0,
              content: {
        ForEach(plants, id: \.id) { plant in
            PlantRow(
                cardColor: .green,
                plant: plant,
                resetFlip: .constant(false),
                onDelete: {
                    //onDelete(plant)
                },
                onEdit: {
                    //onEdit(plant)
                }
            )
        }
    })
    .environment(SensorManager())
    .padding(10)
}
