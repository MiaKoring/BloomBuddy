//
//  PlantRowBack.swift
//  BloomBuddy
//
//  Created by Simon Zwicker on 24.07.24.
//

import SwiftUI

struct PlantRowBack: View {

    let cardColor: Color
    let plant: Plant?
    let onDelete: () -> Void

    var body: some View {
        HStack {
            Image(systemName: "pencil.circle.fill")
                .symbolRenderingMode(.palette)
                .font(.Regular.large)
                .foregroundStyle(
                    .white.opacity(0.8),
                    .blue.opacity(0.4)
                )

            Divider()
                .frame(width: 2, height: 40.0)

            Image(systemName: "trash.circle.fill")
                .symbolRenderingMode(.palette)
                .font(.Regular.large)
                .foregroundStyle(
                    .white.opacity(0.8),
                    .pink.opacity(0.6)
                )
                .button {
                    onDelete()
                }
        }
        .padding(10)
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(cardColor.gradient.opacity(0.15))
        .clipShape(.rect(cornerRadius: 15.0))
    }
}
