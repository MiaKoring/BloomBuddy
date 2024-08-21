//
//  KeyChainManager.swift
//  BloomBuddy
//
//  Created by Mia Koring on 21.08.24.
//

import Foundation
import KeychainAccess

struct KeyChainManager {
    static private let service = "de.touchthegrass.BloomBuddy.app"
    static func setValue(_ value: String?, for key: KeychainKey) {
        let kc = Keychain(service: KeyChainManager.service).synchronizable(false).accessibility(.alwaysThisDeviceOnly)
        kc[key.rawValue] = value
    }
    
    static func getValue(for key: KeychainKey) -> String? {
        let kc = Keychain(service: KeyChainManager.service).synchronizable(false).accessibility(.alwaysThisDeviceOnly)
        return kc[key.rawValue]
    }
}
