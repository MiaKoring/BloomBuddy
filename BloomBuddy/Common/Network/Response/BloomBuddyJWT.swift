//
//  BloomBuddyJWT.swift
//  BloomBuddy
//
//  Created by Mia Koring on 20.08.24.
//

import Foundation

struct BloomBuddyJWT: Codable {
    let expires: Int
    let token: String
}
