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
                }
            ),
            showBack: $showBack,
            resetFlip: $resetFlip
        )
    }
}
