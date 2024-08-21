//
//  BBAuthManager.swift
//  BloomBuddy
//
//  Created by Mia Koring on 21.08.24.
//

import Foundation

struct BBAuthManager {
    static func jwt() async -> Result<String, BloomBuddyApiError> {
        guard let jwt = KeyChainManager.getValue(for: .jwtAuth), UDKey.jwtExpiration.intValue > Int(Date().timeIntervalSinceReferenceDate) else {
            let res = await reauthenticate()
            return res
        }
        return .success(jwt)
    }
    
    private static func reauthenticate() async -> Result<String, BloomBuddyApiError>  {
        guard let basic = KeyChainManager.getValue(for: .basicAuth) else {
            return .failure(.unauthorized)
        }
        
        let res = await BloomBuddyController.request(.loginBasic(basic), expected: BloomBuddyJWT.self)
        
        switch res {
        case .success(let token):
            KeyChainManager.setValue(token.token, for: .jwtAuth)
            UDKey.jwtExpiration.intValue = token.expires
            return .success(token.token)
        case .failure(let failure):
            return .failure(failure)
        }
    }
}
