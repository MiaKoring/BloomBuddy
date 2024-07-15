//
//  CLLocationCoordinate2D.swift
//  HackathonProject1
//
//  Created by Simon Zwicker on 15.07.24.
//

import CoreLocation

extension CLLocationCoordinate2D: Equatable {
    public static func == (lhs: CLLocationCoordinate2D, rhs: CLLocationCoordinate2D) -> Bool {
        (lhs.latitude == rhs.latitude) && (lhs.longitude == rhs.longitude)
    }
}
