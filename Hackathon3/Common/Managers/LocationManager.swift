//
//  LocationManager.swift
//  Hackathon3
//
//  Created by Simon Zwicker on 18.07.24.
//

import Foundation
import CoreLocation

@Observable
class LocationManager: NSObject {
    let manager: CLLocationManager = .init()
    var location: CLLocationCoordinate2D?

    func requestAuth() {
        manager.delegate = self
        manager.requestWhenInUseAuthorization()
        requestLocation()
    }

    func requestLocation() {
        manager.startUpdatingLocation()
    }
}

extension LocationManager: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        self.location = locations.first?.coordinate
    }

    func locationManager(_ manager: CLLocationManager, didFailWithError error: any Error) {
        print("Failed to get location: \(error.localizedDescription)")
    }
}
