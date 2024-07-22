//
//  PlantList.swift
//  BloomBuddy
//
//  Created by Simon Zwicker on 22.07.24.
//

import SwiftUI
import RealmSwift

struct PlantList: View {

    @ObservedResults(Plant.self) var plants
    @State private var showAdd: Bool = false

    var body: some View {
        VStack {
            HStack(spacing: 20.0) {
                Text("Mein Garten")
                    .font(.Bold.title2)

                Image(systemName: "chevron.down")
                    .font(.Bold.regular)

                Spacer()

                Image(systemName: "plus")
                    .foregroundStyle(.plantGreen)
                    .font(.Bold.title2)
                    .button {
                        showAdd.setTrue()
                    }
            }
            .padding(.horizontal, 10.0)

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
                            cardColor: [
                                Color.plantGreen,
                                Color.red,
                                Color.yellow
                            ].randomElement() ?? .plantGreen,
                            plant: plant
                        )
                    }
                })
            }
        }
        .sheet(isPresented: $showAdd, content: {
            PlantDetail()
        })
    }
}

#Preview {
    PlantList()
}
