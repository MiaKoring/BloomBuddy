//
//  NetworkEnv.swift
//  BloomBuddy
//
//  Created by Mia Koring on 18.08.24.
//

import Foundation

enum NetworkEnv {
    case bloombuddy
}

extension NetworkEnv {
    var scheme: String {
        switch self {
        case .bloombuddy: "https"
        }
    }

    var host: String {
        switch self {
        case .bloombuddy: "bloombuddy.touchthegrass.de"
        }
    }

    var path: String {
        ""
    }

    var components: URLComponents {
        var comp = URLComponents()
        comp.scheme = scheme
        comp.host = host
        comp.path = path
        return comp
    }
}
