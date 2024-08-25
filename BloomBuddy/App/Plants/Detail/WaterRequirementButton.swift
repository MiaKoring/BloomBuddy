//
//  WaterRequirementButton.swift
//  BloomBuddy
//
//  Created by Mia Koring on 25.08.24.
//

import SwiftUI

struct WaterRequirementButton: View {
    @Binding var selected: WaterRequirement
    let water: WaterRequirement
    @Environment(\.colorScheme) var colorScheme
    @State var percent: Int
    var editable: Bool = false
    @State var showSheet: Bool = false
    
    init(selected: Binding<WaterRequirement>, water: WaterRequirement, editable: Bool = false) {
        self._selected = selected
        self.water = water
        self.percent = water.percent
        self.editable = editable
    }
    
    var body: some View {
        VStack(spacing: 5) {
            HStack(spacing: 2) {
                ForEach(0..<percent.dropAmount, id: \.self) { watering in
                    Image(systemName: water.image)
                        .symbolEffect(.bounce, value: selected.is(water))
                        .font(.Regular.title3)
                }
            }
            .foregroundStyle(selected.is(water) ? .white: .blue.lighter().opacity(0.25))
            .frame(maxWidth: .infinity)
            
            Text(water.title)
                .font(.Bold.regular)
                .opacity(0.8)
                .foregroundStyle(selected.is(water) ? .white: colorScheme == .dark ? .white.opacity(0.3) : .black.opacity(0.25))
            Text("\(percent)%")
                .font(.Bold.regular)
                .opacity(0.8)
                .foregroundStyle(selected.is(water) ? .white: colorScheme == .dark ? .white.opacity(0.3) : .black.opacity(0.25))
        }
        .padding()
        .frame(width: 100)
        .background(
            RoundedRectangle(cornerRadius: 20.0)
                .fill(selected.is(water) ? .blue.lighter(): .clear)
                .stroke(selected.is(water) ? .blue.lighter(): .black.opacity(0.25), lineWidth: 2)
        )
        .button {
            withAnimation(.easeInOut) {
                if !editable {
                    selected = water
                } else {
                    showSheet = true
                }
            }
        }
        .sheet(isPresented: $showSheet) {
            CustomWaterRequirementSheet(percent: $percent, selected: $selected)
                .padding()
            .interactiveDismissDisabled()
            .presentationDetents([.height(250)])
        }
    }
}
