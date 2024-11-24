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
    @State var hideOldPw: Bool = true
    @State var hideNewPw: Bool = true
    @State var retryTimer: Timer = Timer()
    @State var oldPw: String = ""
    @State var newPw: String = ""
    @State var newPw1: String = ""
    @State var pwInfo: String = ""
    @State var showSuccess: Bool = false
    @State var pwValid: Bool = true
    
    var body: some View {
        ZStack {
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
                                                changeUsername()
                                                editUserName = false
                                                focus = nil
                                            }
                                        }
                                    }
                                    .disabled(editUserName ? (mutableUserName.isEmpty ? true: false): false)
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
                                //userManager.user = User(id: UUID(), name: "MiaCodesSwift", password: "abc") //testing in live preview
                                switch await userManager.fetch() {
                                case .success(let user):
                                    break
                                case .failure(let error):
                                    switch error {
                                    case .unauthorized:
                                        break
                                    default:
                                        self.unexpectedError = error
                                    }
                                }
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
                    BBTextFieldFocusable<Focus>("Altes Passwort", text: $oldPw, focused: $focus, equals: .pwOld, hidden: $hideOldPw)
                    BBTextFieldFocusable<Focus>("Neues Passwort", text: $newPw, focused: $focus, equals: .pwNew1, hidden: $hideNewPw)
                    BBTextFieldFocusable<Focus>("Neues Passwort bestätigen", text: $newPw1, focused: $focus, equals: .pwNew2, hidden: $hideNewPw)
                        .padding(.bottom, 30)
                    HStack {
                        Text(pwInfo)
                            .font(.footnote)
                            .foregroundStyle(.red)
                        Spacer()
                    }
                    .if(pwInfo.isEmpty) { view in
                        view.hidden()
                    }
                    Text("Passwort ändern")
                        .bigButton(valid: pwValid && !oldPw.isEmpty && !retryTimer.isValid) {
                            changePassword()
                        }
                        .disabled(retryTimer.isValid || !pwValid || oldPw.isEmpty)
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
                .onChange(of: mutableUserName) {
                    mutableUserName = mutableUserName.filter({$0.isLetter || $0.isNumber})
                }
                .onChange(of: newPw) { isPwValid() }
                .onChange(of: newPw1) { isPwValid() }
            }
            if showSuccess {
                HStack {
                    Image(systemName: "checkmark.circle")
                        .font(.largeTitle)
                        .foregroundStyle(.plantGreen)
                }
                .frame(width: 75, height: 75)
                .background(.ultraThinMaterial)
                .clipShape(RoundedRectangle(cornerRadius: 15))
            }
        }
    }
    enum Focus {
        case name, pwOld, pwNew1, pwNew2
    }
    
    func changeUsername() {
        Task {
            let res = await BBAuthManager.jwt()
            switch res {
            case .success(let token):
                let res = await BBController.request(.changeUsername(mutableUserName, token), expected: String.self)
                switch res {
                case .success:
                    switch await userManager.fetch() {
                    case .success(let user):
                        showSuccess = true
                        Timer.scheduledTimer(withTimeInterval: 2, repeats: false) { timer in
                            DispatchQueue.main.async {
                                showSuccess = false
                            }
                            timer.invalidate()
                        }
                        guard let pw = KeyChainManager.getValue(for: .basicAuth), let data = Data(base64Encoded: pw), let password = String(data: data, encoding: .utf8)?.split(separator: ":", maxSplits: 1) else { return }
                        
                        KeyChainManager.setValue("\(user.name):\(password)".data(using: .utf8)?.base64EncodedString(), for: .basicAuth)
                        break
                    case .failure(let error):
                        switch error {
                        case .unauthorized:
                            showLogin = true
                        default:
                            self.unexpectedError = error
                        }
                    }
                case .failure(let failure):
                    switch failure {
                    case .unauthorized: showLogin = true
                    default: unexpectedError = failure
                    }
                }
            case .failure(let failure):
                switch failure {
                case .unauthorized: showLogin = true
                default: unexpectedError = failure
                }
            }
        }
    }
    
    func changePassword() {
        Task {
            if !retryTimer.isValid  {
                let res = await BBAuthManager.jwt()
                switch res {
                case .success(let token):
                    let res = await BloomBuddyController.request(.changePassword(oldPw, newPw, token), expected: String.self)
                    switch res {
                    case .success:
                        if let name = userManager.user?.name {
                            KeyChainManager.setValue("\(name):\(newPw)".data(using: .utf8)?.base64EncodedString(), for: .basicAuth)
                        } else {
                            switch await userManager.fetch() {
                            case .success(let user):
                                KeyChainManager.setValue("\(user.name):\(newPw)".data(using: .utf8)?.base64EncodedString(), for: .basicAuth)
                                break
                            case .failure(let error):
                                switch error {
                                case .unauthorized:
                                    break
                                default:
                                    self.unexpectedError = error
                                }
                            }
                        }
                        showSuccess = true
                        Timer.scheduledTimer(withTimeInterval: 2, repeats: false) { timer in
                            DispatchQueue.main.async {
                                showSuccess = false
                            }
                            timer.invalidate()
                        }
                        oldPw = ""
                        newPw = ""
                        newPw1 = ""
                    case .failure(let failure):
                        switch failure {
                        case .unauthorized:
                            pwInfo = "Altes Passwort falsch"
                            retryTimer = Timer.scheduledTimer(withTimeInterval: 10, repeats: false) { timer in
                                DispatchQueue.main.async {
                                    pwInfo = ""
                                }
                                timer.invalidate()
                            }
                        default:
                            unexpectedError = failure
                        }
                    }
                case .failure(let failure):
                    switch failure {
                    case .unauthorized: showLogin = true
                    default: unexpectedError = failure
                    }
                }
                
            } else {
                pwInfo = "Bitte warte 10 Sekunden vor einem erneuten Versuch"
            }
        }
    }
    
    func isPwValid() {
        pwValid = newPw == newPw1 && !newPw.isEmpty
        if !pwValid {
            pwInfo = "Die gewählten Passwörter stimmen nicht überein"
        }
    }
}

#Preview {
    BackgroundView(.plantGreen.opacity(0.15)) {
        AccountView(showSuccess: true)
            .environment(UserManager())
    }
}

