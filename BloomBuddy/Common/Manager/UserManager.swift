//
//  UserManager.swift
//  BloomBuddy
//
//  Created by Mia Koring on 22.11.24.
//

//
//  SensorManager.swift
//  BloomBuddy
//
//  Created by Mia Koring on 21.08.24.
//

import Foundation

@Observable
class UserManager: NSObject {
    var user: User?
    
    func fetch() async -> Result<User, BloomBuddyApiError> {
        let response = await BBAuthManager.jwt()
        var token = ""
        switch response {
        case .success(let success):
            token = success
        case .failure(let failure):
            return .failure(failure)
        }
        
        let res = await BloomBuddyController.request(.info(token), expected: User.self)
        switch res {
        case .success(let success):
            user = success
        case .failure(let failure):
            break
        }
        return res
    }
}

