//
//  URLReqEndpoint.swift
//  BloomBuddy
//
//  Created by Mia Koring on 20.08.24.
//

import Foundation
import Mammut

protocol URLReqEndpoint: Endpoint {
    var urlReqHeaders: [String: String] { get }
}
