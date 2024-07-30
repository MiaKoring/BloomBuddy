//
//  UDKey.swift
//  BloomBuddy
//
//  Created by Simon Zwicker on 22.07.24.
//

import Foundation

enum UDKey: String {
    case onboarding = "showOnboarding"
    case tips = "showTips"
    case collection = "currentCollection"
    case disclaimer = "disclaimerNoticed"
}

extension UDKey {
    var key: String {
        switch self {
        default: self.rawValue
        }
    }

    var stringValue: String {
        get { UserDefaults.standard.string(forKey: self.key) ?? "" }
        nonmutating set { UserDefaults.standard.setValue(newValue, forKey: self.key) }
    }

    var intValue: Int {
        get { UserDefaults.standard.integer(forKey: self.key) }
        nonmutating set { UserDefaults.standard.setValue(newValue, forKey: self.key) }
    }

    var doubleValue: Double {
        get { UserDefaults.standard.double(forKey: self.key) }
        nonmutating set { UserDefaults.standard.setValue(newValue, forKey: self.key) }
    }

    var boolValue: Bool {
        get { UserDefaults.standard.bool(forKey: self.key) }
        nonmutating set { UserDefaults.standard.setValue(newValue, forKey: self.key) }
    }

    var value: Any? {
        get { UserDefaults.standard.object(forKey: self.key) }
        nonmutating set { UserDefaults.standard.setValue(newValue, forKey: self.rawValue) }
    }
}
