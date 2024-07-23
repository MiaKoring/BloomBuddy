//
//  BBTextfieldStyle.swift
//  BloomBuddy
//
//  Created by Simon Zwicker on 23.07.24.
//

import SwiftUI

struct BBTextfieldStyle: TextFieldStyle {
    func _body(configuration: TextField<Self._Label>) -> some View {
        configuration
            .font(.Bold.title2)
            .foregroundStyle(.plantGreen)
            .padding()
            .background(
                RoundedRectangle(cornerRadius: 20.0)
                    .fill(.plantGreen.opacity(0.1))
            )
            .tint(.plantGreen)
    }
}
