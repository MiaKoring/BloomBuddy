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
            Text("Gewünschte Bodenfeuchte")
                .font(.Bold.regularSmall)
                .foregroundStyle(.gray)
                .padding(.horizontal)
            
            ScrollView(.horizontal) {
                HStack(spacing: 15.0) {
                    ForEach(WaterRequirement.allCases, id: \.self) { water in
                        if water.title != WaterRequirement.custom(0).title {
                            WaterRequirementButton(selected: $selected, water: water)
                        } else {
                            WaterRequirementButton(selected: $selected, water: selected.title == WaterRequirement.custom(0).title ? selected: .custom(0), editable: true)
                        }
                    }
                }
                .padding(2)
            }
        }
    }
}
