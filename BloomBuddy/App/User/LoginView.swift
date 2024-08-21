//
//  Login.swift
//  BloomBuddy
//
//  Created by Mia Koring on 20.08.24.
//

import Foundation
import SwiftUI

struct LoginView: View {
    @Environment(\.dismiss) var dismiss
    @Environment(\.colorScheme) var appearance
    @State var name: String = ""
    @State var pwd: String = ""
    @State var pwdConfirm: String = ""
    @State var login: Bool = true
    @State var nameValid: Bool = true
    @State var pwdValid: Bool = true
    @State var loading: Bool = false
    @State var showDisclaimer: Bool = false
    @State var disclaimerNoticed: Bool = false
    @State var fieldErrorMessage: String? = nil
    @State var unexpectedError: BloomBuddyApiError? = nil
    var completion: (DismissAction) -> Void = { dismiss in dismiss() }
    
    @FocusState private var focusedField: LoginField?
    var body: some View {
        ZStack {
            ScrollView {
                VStack(alignment: .leading) {
                    image()
                        .resizable()
                        .scaledToFit()
                        .frame(maxHeight: 300)
                    
                    Section {
                        TextField("Username", text: $name)
                            .textContentType(.username)
                            .focused($focusedField, equals: .name)
                            .loginTextFieldStyle(focusedField: focusedField, appearance: appearance, expected: .name, valid: nameValid)
                        TextField("Passwort", text: $pwd)
                            .textContentType(login ? .password: .newPassword)
                            .focused($focusedField, equals: .pwd)
                            .loginTextFieldStyle(focusedField: focusedField, appearance: appearance, expected: .pwd, valid: pwdValid)
                        if !login {
                            TextField("Passwort bestätigen", text: $pwdConfirm)
                                .textContentType(.newPassword)
                                .focused($focusedField, equals: .pwdConfirm)
                                .loginTextFieldStyle(focusedField: focusedField, appearance: appearance, expected: .pwdConfirm, valid: pwdValid)
                        }
                        if let fieldErrorMessage {
                            Text(fieldErrorMessage)
                                .foregroundStyle(.red)
                                .font(.footnote)
                        }
                        Toggle(isOn: $disclaimerNoticed, label: {
                            disclaimerNoticeText()
                                .font(.footnote)
                                .onTapGesture {
                                    showDisclaimer.toggle()
                                }
                        })
                    } header: {
                        Text(login ? "Login": "Registrieren")
                    }
                    .padding(.horizontal, 2)
                    Text("Anmelden")
                        .bigButton(valid: loginEnabled) {
                            buttonClicked(isLogin: true)
                        }
                        .disabled(!loginEnabled)
                    Text("Registrieren")
                        .bigButton(valid: registerEnabled) {
                            buttonClicked(isLogin: false)
                        }
                        .disabled(!registerEnabled)
                    Spacer()
                }
            }
            .padding(.top)
            .background(.forecastBackground)
            if loading {
                RoundedRectangle(cornerRadius: 25.0)
                    .fill(.gray.opacity(0.5))
                    .frame(width: 100, height: 100)
                    .overlay {
                        ProgressView().progressViewStyle(.circular)
                    }
            }
        }
        .padding(.horizontal, 40)
        .sheet(isPresented: $showDisclaimer) {
            VStack {
                Text("Disclaimer")
                    .font(.title2)
                ScrollView {
                    Text("Trotz größter Sorgfalt bei der Entwicklung und Pflege der App können wir keine Haftung für Schäden übernehmen, die durch die Nutzung von BloomBuddy entstehen. Unsere Empfehlungen basieren nur auf Wahrscheinlichkeiten. Nutzer sollten stets ihre eigene Beurteilung zur Pflege ihrer Pflanzen verwenden.")
                }
                Text("Schließen")
                    .bigButton {
                        showDisclaimer = false
                    }
            }
            .padding(.horizontal, 20)
            .padding(.top, 20)
            .presentationDetents([.height(250)])
        }
        .onChange(of: name) {
            nameValid = !name.isEmpty
            if !nameValid {
                fieldErrorMessage = "Name darf nicht leer sein"
            } else if pwdValid {
                fieldErrorMessage = nil
            } else {
                isPWValid()
            }
        }
        .onChange(of: pwd) { isPWValid() }
        .onChange(of: pwdConfirm) { isPWValid() }
        .alert(item: $unexpectedError) { error in
            Alert(title: Text("Ein unerwarteter Fehler ist aufgetreten"), message: Text(error.localizedDescription)) //TODO: Add error reporting to server
        }
    }
    
    private func buttonClicked(isLogin: Bool) {
        guard toggleLogin(loginClicked: isLogin) else {
            fieldErrorMessage = nil
            return
        }
        
        isPWValid()
        nameValid = !name.isEmpty
        
        guard nameValid, pwdValid else {
            if !pwdValid {
                if pwd.isEmpty {
                    fieldErrorMessage = "Passwort darf nicht leer sein"
                }
            }
            if !nameValid {
                fieldErrorMessage = "Name darf nicht leer sein"
            }
            return
        }
        loading = true
        fieldErrorMessage = nil
        if isLogin {
            Task {
                let res = await BloomBuddyController.request(.login(name, pwd), expected: BloomBuddyJWT.self)
                switch res {
                case .success(let jwt):
                    KeyChainManager.setValue(jwt.token, for: .jwtAuth)
                    KeyChainManager.setValue("\(name):\(pwd)".data(using: .utf8)?.base64EncodedString(), for: .basicAuth)
                    UDKey.jwtExpiration.intValue = jwt.expires
                case .failure(let error):
                    switch error {
                    case .unauthorized: fieldErrorMessage = "Ungültige Anmeldedaten"
                    default: unexpectedError = error
                    }
                    loading = false
                    return
                }
                loading = false
                completion(dismiss)
            }
            return
        }
        Task {
            let res = await BloomBuddyController.request(.createUser(name, pwd), expected: BloomBuddyJWT.self)
            switch res {
            case .success(let jwt):
                KeyChainManager.setValue(jwt.token, for: .jwtAuth)
                KeyChainManager.setValue("\(name):\(pwd)".data(using: .utf8)?.base64EncodedString(), for: .basicAuth)
                UDKey.jwtExpiration.intValue = jwt.expires
            case .failure(let error):
                switch error {
                case .nameUsed: fieldErrorMessage = "Name wird bereits genutzt"
                default: unexpectedError = error
                }
                loading = false
                return
            }
            loading = false
            completion(dismiss)
        }
    }
    
    private func toggleLogin(loginClicked: Bool) -> Bool {
        focusedField = nil
        if login && !loginClicked {
            withAnimation { login = false }
            pwdValid = pwd == pwdConfirm
            return false
        }
        if !login && loginClicked {
            withAnimation { login = true }
            pwdValid = !pwd.isEmpty
            return false
        }
        return true
    }
    
    private func isPWValid() {
        if login {
            pwdValid = !pwd.isEmpty
            if !pwdValid {
                fieldErrorMessage = "Bitte gib dein Passwort ein"
            } else if nameValid {
                fieldErrorMessage = nil
            }
            return
        }
        pwdValid = pwd == pwdConfirm && !pwd.isEmpty
        if pwd != pwdConfirm {
            fieldErrorMessage = "Passwörter stimmen nicht überein"
        } else if nameValid {
            fieldErrorMessage = nil
        }
    }
    
    private func image() -> Image {
        switch appearance {
        case .light:
            Image("LoginLight")
        case .dark:
            Image("LoginDark")
        @unknown default:
            Image("LoginLight")
        }
    }
    
    private func disclaimerNoticeText() -> Text {
        Text("*Ich habe den ") + Text("Disclaimer").foregroundStyle(.blue) + Text(" gelesen und stimme zu.")
    }
    
}

extension LoginView {
    var loginEnabled: Bool {
        !login || (pwdValid && nameValid  && disclaimerNoticed)
    }
    var registerEnabled: Bool {
        login || (pwdValid && nameValid && disclaimerNoticed)
    }
}

#Preview {
    VStack {}
        .sheet(isPresented: .constant(true), content: {
            LoginView() { dismiss in
                print("succeeded")
                dismiss()
            }
                .presentationDragIndicator(.visible)
                .interactiveDismissDisabled()
        })
}
