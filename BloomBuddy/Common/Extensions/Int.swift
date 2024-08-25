//
//  Int.swift
//  BloomBuddy
//
//  Created by Mia Koring on 25.08.24.
//

extension Int {
    var dropAmount: Int {
        switch self {
        case 0...30: 1
        case 31...60: 2
        default: 3
        }
    }
}
