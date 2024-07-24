//
//  PlantList.swift
//  BloomBuddy
//
//  Created by Simon Zwicker on 23.07.24.
//

import SwiftUI
import CoreData

struct PlantList: View {

    // MARK: - Properties
    @FetchRequest var plants: FetchedResults<Plant>
    let onDelete: (Plant) -> Void

    init(_ request: NSFetchRequest<Plant>, onDelete: @escaping (Plant) -> Void) {
        _plants = FetchRequest(fetchRequest: request)
        self.onDelete = onDelete
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
                    ZStack {
                        PlantRow(
                            cardColor: [
                                Color.plantGreen,
                                Color.red,
                                Color.yellow
                            ].randomElement() ?? .plantGreen,
                            plant: plant, 
                            onDelete: {
                                onDelete(plant)
                            }
                        )
                    }
                }
            })
        }
    }
}
