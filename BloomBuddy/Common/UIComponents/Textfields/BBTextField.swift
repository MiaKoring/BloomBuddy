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
    var hidden: Binding<Bool>?

    init(_ placeholder: LocalizedStringKey, text: Binding<String>, hidden: Binding<Bool>? = nil) {
        self.placeholder = placeholder
        self._text = text
        self.hidden = hidden
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 5) {
            Text(placeholder)
                .font(.Bold.regularSmall)
                .foregroundStyle(.gray)
                .padding(.horizontal)
            if let hidden, hidden.wrappedValue {
                SecureField("", text: $text)
                    .autocorrectionDisabled()
                    .textFieldStyle(BBTextfieldStyle())
                    .textInputAutocapitalization(.never)
            } else {
                TextField("", text: $text)
                    .autocorrectionDisabled()
                    .textFieldStyle(BBTextfieldStyle())
                    .textInputAutocapitalization(.never)
            }
        }
    }
}
struct BBTextFieldFocusable<T: Hashable>: View {

    let placeholder: LocalizedStringKey
    @Binding var text: String
    @FocusState.Binding var focused: T?
    let equals: T
    var hidden: Binding<Bool>?

    init(_ placeholder: LocalizedStringKey, text: Binding<String>, focused: FocusState<T?>.Binding, equals: T, hidden: Binding<Bool>? = nil) {
        self.placeholder = placeholder
        self._text = text
        self._focused = focused
        self.equals = equals
        self.hidden = hidden
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 5) {
            Text(placeholder)
                .font(.Bold.regularSmall)
                .foregroundStyle(.gray)
                .padding(.horizontal)
            if let hidden {
                ZStack {
                    SecureField("", text: $text)
                        .autocorrectionDisabled()
                        .focused($focused, equals: equals)
                        .textFieldStyle(BBTextfieldStyle())
                        .textInputAutocapitalization(.never)
                        .if(!hidden.wrappedValue) { view in
                            view.hidden()
                        }
                    TextField("", text: $text)
                        .autocorrectionDisabled()
                        .focused($focused, equals: equals)
                        .textFieldStyle(BBTextfieldStyle())
                        .textInputAutocapitalization(.never)
                        .if(hidden.wrappedValue) { view in
                            view.hidden()
                        }
                }
                .overlay(alignment: .trailing) {
                    Image(systemName: hidden.wrappedValue ? "eye": "eye.slash")
                        .padding(.trailing)
                        .if(true) { view in
                            if #available(iOS 18.0, *) {
                                view.contentTransition(.symbolEffect(.replace.magic(fallback: .replace.downUp)))
                            } else {
                                view.contentTransition(.symbolEffect(.replace.downUp))
                            }
                        }
                        .button {
                            withAnimation(.linear(duration: 0.2)) {
                                hidden.wrappedValue.toggle()
                            }
                        }
                }
            } else {
                TextField("", text: $text)
                    .autocorrectionDisabled()
                    .focused($focused, equals: equals)
                    .textFieldStyle(BBTextfieldStyle())
                    .textInputAutocapitalization(.never)
            }
        }
    }
}

#Preview {
    BBTextField("Name der Pflanze", text: .constant("Test"))
}
