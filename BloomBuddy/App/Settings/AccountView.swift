//
//  AccountView.swift
//  BloomBuddy
//
//  Created by Mia Koring on 22.11.24.
//

import SwiftUI

struct AccountView: View {
    @Environment(UserManager.self) var userManager
    @State var showLogin: Bool = false
    @State var unexpectedError: BloomBuddyApiError? = nil
    @State var editUserName: Bool = false
    @FocusState var focus: Focus?
    @State var mutableUserName: String = ""
    var body: some View {
        ScrollView {
            VStack {
                Image("plantBg")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .overlay {
                        Color.plantGreen.lighter().opacity(0.4)
                    }
                    .clipped()
                    .clipShape(Circle())
                    .shadow(color: .white.opacity(0.3), radius: 2)
                    .overlay {
                        Image("UserIcon")
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .foregroundStyle(.white.darker())
                            .frame(maxHeight: 170)
                    }
                    .frame(maxHeight: 200)
                    .padding(.bottom)
                HStack {
                    Text("Nutzername")
                        .font(.footnote)
                        .foregroundStyle(.primary.opacity(0.7))
                    Spacer()
                }
                VStack {
                    if let username = userManager.user?.name {
                        HStack {
                            ZStack {
                                HStack {
                                    Text(username)
                                        .font(.system(size: 25))
                                        .bold()
                                    Spacer()
                                }
                                .contentShape(Rectangle())
                                .onTapGesture {
                                    mutableUserName = username
                                    editUserName = true
                                    focus = .name
                                }
                                .if(editUserName) { view in
                                    view.hidden()
                                }
                                TextField(text: $mutableUserName) {
                                    Text("Nutzername")
                                }
                                .focused($focus, equals: .name)
                                .font(.system(size: 25))
                                .bold()
                                .if(!editUserName) { view in
                                    view.hidden()
                                }
                                
                            }
                            
                            Image(systemName: editUserName ? "checkmark.circle": "pencil.circle")
                                .contentTransition(.symbolEffect(.replace.downUp))
                                .font(.system(size: 25))
                                .bold()
                                .button {
                                    withAnimation(.linear(duration: 0.2)) {
                                        if !editUserName {
                                            mutableUserName = username
                                            editUserName = true
                                            focus = .name
                                        } else {
                                            editUserName = false
                                            focus = nil
                                        }
                                    }
                                }
                        }
                    } else {
                        HStack {
                            ZStack {
                                HStack {
                                    Text("Lädt...")
                                        .font(.system(size: 25))
                                        .bold()
                                    Spacer()
                                }
                                .contentShape(Rectangle())
                                TextField(text: $mutableUserName) {
                                    Text("Nutzername")
                                }
                                .font(.system(size: 25))
                                .bold()
                                .hidden()
                                
                            }
                            
                            Image(systemName: "pencil.circle")
                                .font(.system(size: 25))
                                .bold()
                                .button {
                                }
                        }
                        .task {
                            userManager.user = User(id: UUID(), name: "MiaCodesSwift", password: "abc")
                            /*
                             switch await userManager.fetch() {
                             case .success(let user):
                             break
                             case .failure(let error):
                             switch error {
                             case .unauthorized:
                             showLogin = true
                             default:
                             self.unexpectedError = error
                             }
                             }
                             }*/
                        }
                    }
                }
                .padding(.bottom)
                Divider()
                    .padding(.bottom)
                HStack {
                    Text("Passwort ändern")
                        .bold()
                    Spacer()
                }
                .padding(.bottom)
                BBTextFieldFocusable<Focus>("Altes Passwort", text: .constant("Test"), focused: $focus, equals: .pwOld)
                BBTextFieldFocusable<Focus>("Neues Passwort", text: .constant("Test"), focused: $focus, equals: .pwNew1)
                BBTextFieldFocusable<Focus>("Neues Passwort bestätigen", text: .constant("Test"), focused: $focus, equals: .pwNew2)
                    .padding(.bottom, 30)
                Text("Passwort ändern")
                    .bigButton {
                        
                    }
                Spacer()
            }
            .sheet(isPresented: $showLogin) {
                Task {
                    switch await userManager.fetch() {
                    case .success:
                        break
                    case .failure(let error):
                        switch error {
                        case .unauthorized:
                            showLogin = true
                        default:
                            unexpectedError = error
                        }
                    }
                }
            } content: {
                LoginView()
            }
            .alert(item: $unexpectedError) { error in
                Alert(title: Text("Ein unerwarteter Fehler ist aufgetreten"), message: Text(error.localizedDescription)) //TODO: Add error reporting to server
            }
            .padding()
            .contentShape(Rectangle())
            .onTapGesture {
                focus = nil
                editUserName = false
            }
        }
        
    }
    
    enum Focus {
        case name, pwOld, pwNew1, pwNew2
    }
}

#Preview {
    BackgroundView(.plantGreen.opacity(0.15)) {
        AccountView()
            .environment(UserManager())
    }
}
