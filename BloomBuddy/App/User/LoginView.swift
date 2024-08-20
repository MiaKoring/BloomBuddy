//
//  Login.swift
//  BloomBuddy
//
//  Created by Mia Koring on 20.08.24.
//

import Foundation
import SwiftUI

struct LoginView: View {
    @Environment(\.colorScheme) var appearance
    @State var name: String = ""
    @State var pwd: String = ""
    @State var pwdConfirm: String = ""
    @State var login: Bool = true
    @State var nameValid: Bool = true
    @State var pwdValid: Bool = true
    @State var loading: Bool = false
    
    @FocusState private var focusedField: LoginField?
    var body: some View {
        ZStack {
            ScrollView {
                VStack(alignment: .leading) {
                    switch appearance {
                    case .light:
                        Image("LoginLight")
                            .resizable()
                            .scaledToFit()
                            .frame(maxHeight: 300)
                    case .dark:
                        Image("LoginDark")
                            .resizable()
                            .scaledToFit()
                            .frame(maxHeight: 300)
                    @unknown default:
                        Image("LoginLight")
                            .resizable()
                            .scaledToFit()
                            .frame(maxHeight: 300)
                    }
                    
                    
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
                    } header: {
                        Text(login ? "Login": "Registrieren")
                    }
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
            .padding(.horizontal, 40)
            .background(.forecastBackground)
            .onChange(of: name) {
                nameValid = !name.isEmpty
            }
            .onChange(of: pwd) { isPWValid() }
            .onChange(of: pwdConfirm) { isPWValid() }
            if loading {
                RoundedRectangle(cornerRadius: 25.0)
                    .fill(.gray.opacity(0.5))
                    .frame(width: 100, height: 100)
                    .overlay {
                        ProgressView().progressViewStyle(.circular)
                    }
            }
        }
    }
    
    private func buttonClicked(isLogin: Bool) {
        guard toggleLogin(loginClicked: isLogin) else {
            return
        }
        isPWValid()
        nameValid = !name.isEmpty
        guard nameValid, pwdValid else { return } //TODO: Add alert or error message
        if isLogin {
            Task {//TODO: Fiy Mammut error 1
                do {
                    let response = try await Network.request(String.self, environment: .bloombuddy, endpoint: BloomBuddyAPI.login(name, pwd))
                    print(response)
                } catch {
                    print(error.localizedDescription)
                }
            }
            return
        }
        Task {
            do {
                let response = try await Network.request(BloomBuddyJWT.self, environment: .bloombuddy, endpoint: BloomBuddyAPI.createUser(name, pwd))
                print(response)
            } catch {
                print(error.localizedDescription)
            }
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
            return
        }
        pwdValid = pwd == pwdConfirm && !pwd.isEmpty
    }
    
}

extension LoginView {
    var loginEnabled: Bool {
        !login || (pwdValid && nameValid)
    }
    var registerEnabled: Bool {
        login || (pwdValid && nameValid)
    }
}

#Preview {
    VStack {}
        .sheet(isPresented: .constant(true), content: {
            LoginView()
                .presentationDragIndicator(.visible)
                .interactiveDismissDisabled()
        })
}
