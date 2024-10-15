//
//  PlantList.swift
//  BloomBuddy
//
//  Created by Simon Zwicker on 22.07.24.
//

import SwiftUI
import SwiftData
struct PlantsScreen: View {
    
    @Bindable var collection: PlantCollection
    @State private var showAdd: Bool = false
    @State var editPlant: Plant? = nil
    @State var showSettings: Bool = false
    
    let refresh: () -> Void
    let refreshSensors: () -> Void

    var body: some View {
        VStack {
            HStack(spacing: 20.0) {
                Text(collection.name)
                    .font(.Bold.title2)

                // TODO: - Next Feature, different PlantCollections
//                Image(systemName: "chevron.down")
//                    .font(.Bold.regular)
                Spacer()
                Image(systemName: "arrow.counterclockwise")
                    .foregroundStyle(.plantGreen)
                    .font(.Bold.title2)
                    .button {
                        refreshSensors()
                    }
                Image(systemName: "gear")
                    .foregroundStyle(.plantGreen)
                    .font(.Bold.title2)
                    .button {
                        showSettings.setTrue()
                    }
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

            PlantList(collection.plants) { plant in
                withAnimation {
                    collection.plants.removeAll(where: {$0.id == plant.id})
                }
            } onEdit: { plant in
                editPlant = plant
            }
        }
        .sheet(isPresented: $showAdd) {
            PlantDetailAdd(collection: collection)
        }
        .sheet(item: $editPlant, onDismiss: refresh) {plant in
            PlantDetailAdd(collection: collection, edit: true, plant: plant)
        }
        .sheet(isPresented: $showSettings) {
            FAQNavigation()
        }
    }
}
