//
//  LocationManager.swift
//  HackathonProject1
//
//  Created by Simon Zwicker on 15.07.24.
//

import Foundation
import CoreLocation

@Observable
class LocationManager: NSObject {
    let manager: CLLocationManager = .init()
    var location: CLLocationCoordinate2D?
    private let geocoder = CLGeocoder()

    var city: String = ""
    var country: String = ""
    var wasUpdated: Bool = false

    func requestAuth() {
        manager.delegate = self
        manager.requestWhenInUseAuthorization()
        requestLocation()
    }

    func requestLocation() {
        manager.startUpdatingLocation()
    }

    func fetchCityAndCountry(from location: CLLocation, completion: @escaping (String?, String?, Error?) -> ()) {
        geocoder.reverseGeocodeLocation(location) { placemarks, error in
            completion(placemarks?.first?.locality,
                       placemarks?.first?.isoCountryCode,
                       error)
        }
    }
}

extension LocationManager: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard !wasUpdated else { return }
        location = locations.first?.coordinate
        guard let firstLocation = locations.first else { return }
        fetchCityAndCountry(from: firstLocation) { city, country, error in
            guard let city = city, let country = country, error == nil else { return }
            DispatchQueue.main.async {
                self.city = city
                self.country = country
            }
        }
        manager.stopUpdatingLocation()
        wasUpdated.setTrue()
    }

    func locationManager(_ manager: CLLocationManager, didFailWithError error: any Error) {
        print("Error on getting Location: \(error.localizedDescription)")
    }
}
