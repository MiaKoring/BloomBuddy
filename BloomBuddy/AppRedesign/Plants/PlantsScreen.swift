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

            PlantList(collection.plantsRequest) { plant in
                CoreDataProvider.shared.deletePlant(plant, collection: collection)
            }
        }
        .sheet(isPresented: $showAdd) {
            PlantDetailAdd(collection: collection)
        }
    }
}
