//
//  SettingsGroup.swift
//  BloomBuddy
//
//  Created by Mia Koring on 22.11.24.
//

import SwiftUI

enum SettingsGroup: CaseIterable {
    case account
    case help
    case law
    case other
}

extension SettingsGroup: NavigationGroups {
    var id: Int {
        self.hashValue
    }
    
    var children: [Settings] {
        switch self {
        case .account:
            [.account, .sensors, .notifications, .subscriptions, .devices]
        case .help:
            [.faq, .collectedData]
        case .law:
            [.privacy, .agb, .eula]
        case .other:
            [.licenses]
        }
    }
    
    var title: String? {
        switch self {
        case .account:
            nil
        case .help:
            "Informationen"
        case .law:
            "Rechtliches"
        case .other:
            "Anderes"
        }
    }
}
