//
//  Settings.swift
//  BloomBuddy
//
//  Created by Mia Koring on 22.11.24.
//
import SwiftUI

enum Settings: CaseIterable {
    case account
    case sensors
    case notifications
    case subscriptions
    case devices
    case faq
    case privacy
    case agb
    case collectedData
    case eula
    case licenses
}

extension Settings: Navigation {
    var id: Int {
        self.hashValue
    }
    
    var button: AnyView {
        return AnyView(buttonView())
    }
    
    var view: AnyView {
        AnyView(destinationView())
    }
    
    var searchMatches: [String] {
        []
    }
    
    var fullDivider: Bool {
        switch self {
        case .account: true
        default: false
        }
    }
    
    @ViewBuilder
    func destinationView() -> some View {
        switch self {
        case .account:
            AccountView()
        case .sensors:
            Text("test")
        case .notifications:
            Text("test")
        case .subscriptions:
            Text("test")
        case .devices:
            Text("test")
        case .faq:
            Text("test")
        case .privacy:
            Text("test")
        case .agb:
            Text("test")
        case .collectedData:
            Text("test")
        case .eula:
            Text("test")
        case .licenses:
            Text("test")
        }
    }
    
    @ViewBuilder
    func buttonView() -> some View {
        switch self {
        case .account:
            UserDisplay()
        case .sensors:
            NavigationButton(image: Image("SensorIcon"), title: "Sensoren", imageWidth: 30)
        case .notifications:
            NavigationButton(image: Image(systemName: "bell.badge"), title: "Benachrichtigungen")
        case .subscriptions:
            NavigationButton(image: Image(systemName: "plus.arrow.trianglehead.clockwise"), title: "Abonement")
        case .devices:
            NavigationButton(image: Image(systemName: "iphone.gen2.motion"), title: "Geräte")
        case .faq:
            NavigationButton(image: Image(systemName: "questionmark"), title: "FAQ")
        case .privacy:
            NavigationButton(image: Image(systemName: "hand.raised"), title: "Datenschutzerklärung")
        case .agb:
            NavigationButton(image: Image(systemName: "scroll"), title: "Allgemeine Geschäftsbedingungen")
        case .collectedData:
            NavigationButton(image: Image(systemName: "folder.circle"), title: "Deine Daten")
        case .licenses:
            NavigationButton(image: Image(systemName: "network"), title: "Drittanbieterinhalte")
        case .eula:
            NavigationButton(image: Image(systemName: "lock.shield"), title: "Nutzungsbedingungen")
        }
    }
    
    var destinationTitle: String {
        switch self {
        case .account:
            "Account"
        case .sensors:
            "Sensoren"
        case .notifications:
            "Benachrichtigungen"
        case .subscriptions:
            "Abonnement"
        case .devices:
            "Geräte"
        case .faq:
            "FAQ"
        case .privacy:
            "Datenschutzerklärung"
        case .agb:
            "AGBs"
        case .collectedData:
            "Deine Daten"
        case .eula:
            "Nutzungsbedingungen"
        case .licenses:
            "Drittanbieterinhalte"
        }
    }
    
    struct UserDisplay: View {
        @State var username: String? = nil
        @State var showLogin: Bool = false
        @State var error: BloomBuddyApiError?
        @Environment(UserManager.self) var userManager
        var body: some View {
            HStack {
                Image("plantBg")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .overlay {
                        Color.plantGreen.lighter().opacity(0.4)
                    }
                    .clipped()
                    .clipShape(RoundedRectangle(cornerRadius: 15))
                    .shadow(color: .white.opacity(0.3), radius: 2)
                    .overlay {
                        Image("UserIcon")
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .foregroundStyle(.white.darker())
                            .frame(maxHeight: 40)
                    }
                    .frame(maxHeight: 50)
                if let username = userManager.user?.name {
                    Text(username)
                        .font(.Bold.title)
                } else {
                    Text("Lädt...")
                        .font(.Bold.title)
                        .task {
                            switch await userManager.fetch() {
                            case .success(let user):
                                username = user.name
                            case .failure(let error):
                                switch error {
                                case .unauthorized:
                                    showLogin = true
                                default:
                                    self.error = error
                                }
                            }
                        }
                }
                Spacer()
            }
            .sheet(isPresented: $showLogin) {
                LoginView()
            }
            .alert(item: $error) { error in
                Alert(title: Text("Ein unerwarteter Fehler ist aufgetreten"), message: Text(error.localizedDescription)) //TODO: Add error reporting to server
            }
        }
    }
}
