//
//  Data.swift
//  BloomBuddy
//
//  Created by Mia Koring on 19.10.24.
//
import Foundation

extension Data {
    
    init?(base64URLEncoded string: String) {
        var base64 = string
            .replacingOccurrences(of: "-", with: "+")
            .replacingOccurrences(of: "_", with: "/")
        
        // Padding falls notwendig hinzufügen
        while base64.count % 4 != 0 {
            base64.append("=")
        }
        
        guard let data = Data(base64Encoded: base64) else {
            return nil
        }
        
        self = data
    }
    
    init?(base64URLEncoded string: Substring) {
        var base64 = string
            .replacingOccurrences(of: "-", with: "+")
            .replacingOccurrences(of: "_", with: "/")
        
        // Padding falls notwendig hinzufügen
        while base64.count % 4 != 0 {
            base64.append("=")
        }
        
        guard let data = Data(base64Encoded: base64) else {
            return nil
        }
        
        self = data
    }
}
