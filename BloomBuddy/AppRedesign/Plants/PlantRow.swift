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
    let onDelete: () -> Void
	let onEdit: () -> Void
    @State var showEdit: Bool = false
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
                onDelete: onDelete
            ),
            showBack: $showBack
        )

    
    }
}
