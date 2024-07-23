//
//  WaterRequirementButtons.swift
//  BloomBuddy
//
//  Created by Simon Zwicker on 23.07.24.
//

import SwiftUI

struct WaterRequirementButtons: View {

    // MARK: - Properties
    @Binding var selected: WaterRequirement

    var body: some View {
        VStack(alignment: .leading, spacing: 5.0) {
            Text("Wasserbedarf")
                .font(.Bold.regularSmall)
                .foregroundStyle(.gray)
                .padding(.horizontal)

            HStack(spacing: 15.0) {
                ForEach(WaterRequirement.allCases, id: \.self) { water in
                    VStack(spacing: 5) {
                        HStack(spacing: 2) {
                            ForEach(0..<water.amount, id: \.self) { watering in
                                Image(systemName: water.image)
                                    .symbolEffect(.bounce, value: selected.is(water))
                                    .font(.Regular.title3)
                            }
                        }
                        .foregroundStyle(selected.is(water) ? .white: .blue.lighter().opacity(0.25))
                        .frame(maxWidth: .infinity)

                        Text(water.rawValue)
                            .font(.Bold.regular)
                            .opacity(0.8)
                            .foregroundStyle(selected.is(water) ? .white: .black.opacity(0.25))
                    }
                    .padding()
                    .background(
                        RoundedRectangle(cornerRadius: 20.0)
                            .fill(selected.is(water) ? .blue.lighter(): .clear)
                            .stroke(selected.is(water) ? .blue.lighter(): .black.opacity(0.25), lineWidth: 2)
                    )
                    .button {
                        withAnimation(.easeInOut) {
                            selected = water
                        }
                    }
                }
            }
        }
    }
}
