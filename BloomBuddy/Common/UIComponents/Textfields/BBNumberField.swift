//
//  BBNumberField.swift
//  BloomBuddy
//
//  Created by Simon Zwicker on 23.07.24.
//

import SwiftUI

struct BBNumberField: View {

    // MARK: - Properties
    let placeholder: LocalizedStringKey
    @Binding var value: Double
    let decimalPlaces: Int
    private let formatter = NumberFormatter()

    init(_ placeholder: LocalizedStringKey, value: Binding<Double>, _ decimalPlaces: Int = 0) {
        self.placeholder = placeholder
        self._value = value
        self.decimalPlaces = decimalPlaces
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 5) {
            Text(placeholder)
                .font(.Bold.regularSmall)
                .foregroundStyle(.gray)
                .padding(.horizontal)

            TextField("", value: $value, formatter: formatter.digits(decimalPlaces))
                .textFieldStyle(BBTextfieldStyle())
                .keyboardType(decimalPlaces == 0 ? .numberPad: .decimalPad)
        }
    }
}

#Preview {
    BBNumberField("Größe in cm", value: .constant(120.0))
}
