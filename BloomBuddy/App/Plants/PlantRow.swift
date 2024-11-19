//
//  PlantRow.swift
//  BloomBuddy
//
//  Created by Simon Zwicker on 22.07.24.
//

import SwiftUI

struct PlantRow: View {

    let cardColor: Color
    let plant: Plant?
    @Binding var resetFlip: Bool
    let onDelete: () -> Void
	let onEdit: () -> Void
	@State var showBack: Bool = false
    @Environment(\.managedObjectContext) private var viewContext
    @Environment(PlantCollection.self) var collection
	var body: some View {
        FlipView(
            frontView: PlantRowFront(
                cardColor: cardColor,
                plant: plant
            ),
            backView: PlantRowBack(
                cardColor: cardColor,
                plant: plant,
                onDelete: onDelete,
                onEdit: {
                    withAnimation(.linear(duration: 0.2)) {
                        showBack = false
                    }
                    onEdit()
                },
                onWater: {
                    guard let plant = collection.plants.first(where: {$0.id == plant?.id}) else { return }
                    plant.lastWatered = Date().timeIntervalSinceReferenceDate
                    viewContext.refreshAllObjects()
                    withAnimation(.linear(duration: 0.2)) {
                        showBack = false
                    }
                }
            ),
            showBack: $showBack,
            resetFlip: $resetFlip
        )
    }
}
