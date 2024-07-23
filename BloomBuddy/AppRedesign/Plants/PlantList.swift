//
//  PlantList.swift
//  BloomBuddy
//
//  Created by Simon Zwicker on 23.07.24.
//

import SwiftUI
import RealmSwift

struct PlantList: View {

    @ObservedRealmObject var collection: PlantCollection

    var body: some View {
        if collection.plants.isEmpty {
            ContentUnavailableView(
                "Pflanzen anlegen",
                systemImage: "leaf",
                description: Text("Drücke auf das Plus um Pflanzen aus deinem Garten anzulegen.")
            )
        } else {
            LazyVGrid(columns: [.init(), .init()],
                      spacing: 10.0,
                      content: {
                ForEach(collection.plants, id: \.id) { plant in
                    ZStack {
                        PlantRow(
                            cardColor: [
                                Color.plantGreen,
                                Color.red,
                                Color.yellow
                            ].randomElement() ?? .plantGreen,
                            plant: plant
                        )

                        Image(systemName: "trash.circle.fill")
                        symbolRenderingMode(.palette)
                        .font(.Regular.small)
                        .foregroundStyle(
                            .plantGreen.darker().opacity(0.8),
                            .plantGreen.lighter().opacity(0.4)
                        )
                        .button {
                            remove(plant)
                        }
                    }
                }
            })
        }
    }

    private func remove(_ plant: Plant) {
        guard let index = collection.plants.index(of: plant) else { return }
        $collection.plants.remove(at: index)
    }
}
