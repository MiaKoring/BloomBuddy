//
//  PlantList.swift
//  BloomBuddy
//
//  Created by Simon Zwicker on 22.07.24.
//

import SwiftUI
struct PlantsScreen: View {

    let collection: PlantCollection
    @State private var showAdd: Bool = false

    var body: some View {
        VStack {
            HStack(spacing: 20.0) {
                Text(collection.name ?? "")
                    .font(.Bold.title2)

                // TODO: - Next Feature, different PlantCollections
//                Image(systemName: "chevron.down")
//                    .font(.Bold.regular)

                Spacer()

                Image(systemName: "plus")
                    .foregroundStyle(.plantGreen)
                    .font(.Bold.title2)
                    .button {
                        showAdd.setTrue()
                    }
            }
            .padding(.horizontal, 10.0)

            PlantList(collection.plantsRequest) { plant in
                CoreDataProvider.shared.deletePlant(plant, collection: collection)
            }
        }
        .sheet(isPresented: $showAdd) {
            PlantDetailAdd(collection: collection)
        }
    }
}
