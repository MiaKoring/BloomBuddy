//
//  CustomWaterRequirementSheet.swift
//  BloomBuddy
//
//  Created by Mia Koring on 25.08.24.
//

import SwiftUI

struct CustomWaterRequirementSheet: View {
    @Environment(\.colorScheme) var colorScheme
    @Environment(\.dismiss) var dismiss
    @Binding var percent: Int
    @State var internalPercent: Int
    @Binding var selected: WaterRequirement
    
    init(percent: Binding<Int>, selected: Binding<WaterRequirement>) {
        self._percent = percent
        self.internalPercent = percent.wrappedValue
        self._selected = selected
    }
    
    var body: some View {
        Picker("Prozent", selection: $internalPercent) {
            ForEach([0, 10, 15, 25, 30, 35, 40, 45, 55, 60, 65, 70, 75, 85, 90, 95, 100], id: \.self) { percent in
                Text("\(percent)").tag(percent)
            }
        }
            .pickerStyle(.wheel)
            .overlay(alignment: .topTrailing) {
                VStack {
                    HStack {
                        Spacer()
                        Image(systemName: "xmark.circle.fill")
                            .symbolRenderingMode(.palette)
                            .font(.Regular.large)
                            .foregroundStyle(
                                .plantGreen.darker().opacity(colorScheme == .light ? 0.8: 1),
                                .plantGreen.lighter().opacity(colorScheme == .light ? 0.4: 0.6)
                            )
                            .button {
                                dismiss()
                            }
                    }
                    Spacer()
                }
                .padding()
                .offset(x: 20, y: -20)
            }
        Text("Übernehmen")
            .bigButton {
                selected = .custom(internalPercent)
                percent = internalPercent
                dismiss()
            }
    }
}
