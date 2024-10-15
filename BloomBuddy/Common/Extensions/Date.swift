//
//  Date.swift
//  BloomBuddy
//
//  Created by Mia Koring on 27.08.24.
//
import SwiftChameleon
import Foundation

extension Date {
    static func hmAgo(date: Date) -> String {
        let difference = Date.now.timeIntervalSinceReferenceDate - date.timeIntervalSinceReferenceDate
        switch difference {
        case 0...59:
            return "\(difference.roundedInt)s"
        case 60...3589:
            let minutes = (difference / 60.0).roundedInt
            return "\(minutes)m"
        case 3590...79100:
            let hours = (difference / 3600.0).roundedInt
            return "\(hours)h"
        default:
            let days = (difference / 79200.0).roundedInt
            return "\(days)d"
        }
    }
}
