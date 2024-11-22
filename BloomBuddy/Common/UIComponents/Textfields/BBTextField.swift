//
//  BBTextField.swift
//  BloomBuddy
//
//  Created by Simon Zwicker on 23.07.24.
//

import SwiftUI

struct BBTextField: View {

    let placeholder: LocalizedStringKey
    @Binding var text: String

    init(_ placeholder: LocalizedStringKey, text: Binding<String>) {
        self.placeholder = placeholder
        self._text = text
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 5) {
            Text(placeholder)
                .font(.Bold.regularSmall)
                .foregroundStyle(.gray)
                .padding(.horizontal)

            TextField("", text: $text)
                .textFieldStyle(BBTextfieldStyle())
                .textInputAutocapitalization(.never)
        }
    }
}
struct BBTextFieldFocusable<T: Hashable>: View {

    let placeholder: LocalizedStringKey
    @Binding var text: String
    @FocusState.Binding var focused: T?
    let equals: T

    init(_ placeholder: LocalizedStringKey, text: Binding<String>, focused: FocusState<T?>.Binding, equals: T) {
        self.placeholder = placeholder
        self._text = text
        self._focused = focused
        self.equals = equals
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 5) {
            Text(placeholder)
                .font(.Bold.regularSmall)
                .foregroundStyle(.gray)
                .padding(.horizontal)

            TextField("", text: $text)
                .focused($focused, equals: equals)
                .textFieldStyle(BBTextfieldStyle())
                .textInputAutocapitalization(.never)
        }
    }
}

#Preview {
    BBTextField("Name der Pflanze", text: .constant("Test"))
}
