//
//  View.swift
//  BloomBuddy
//
//  Created by Mia Koring on 20.08.24.
//

import Foundation
import SwiftUI

extension View {
    func loginTextFieldStyle(focusedField: LoginField?, appearance: ColorScheme, expected: LoginField, valid: Bool) -> some View {
        self
            .padding(5)
            .background(appearance == .light ? .white : .black)
            .cornerRadius(5)
            .overlay(
                RoundedRectangle(cornerRadius: 5)
                    .stroke(
                        valid ? 
                            (focusedField == expected ?
                                Color.blue:
                                Color.gray.opacity(0.5)):
                            Color.red
                        , lineWidth: 0.5
                    )
            )
    }
    
    func bigButton(valid: Bool? = nil, invalidBg: Color = .gray.opacity(0.4), clicked: @escaping () -> Void) -> some View {
        self
            .font(.Bold.title)
            .padding()
            .frame(maxWidth: .infinity, idealHeight: 60.0)
            .foregroundStyle(.white)
            .background {
                if let valid {
                    RoundedRectangle(cornerRadius: 20.0)
                        .fill(valid ? .plantGreen: invalidBg)
                } else {
                    RoundedRectangle(cornerRadius: 20.0)
                        .fill(.plantGreen)
                }
            }
            .button {
                clicked()
            }
    }
}
