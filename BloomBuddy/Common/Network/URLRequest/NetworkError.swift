//
//  NetworkError.swift
//  BloomBuddy
//
//  Created by Mia Koring on 20.08.24.
//

import Foundation

enum NetworkError: Error {
    case invalidUrl
    case jsonEncoding
    case responseDecode
}
