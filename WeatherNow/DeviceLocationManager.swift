//
//  LocationManager.swift
//  WeatherNow
//
//  Created by Artem Kolpakov on 5/27/24.
//

import Foundation
import MapKit

@MainActor
class DeviceLocationManager: NSObject, ObservableObject {
    @Published var location: CLLocation?
    @Published var region = MKCoordinateRegion()
    
    private let deviceLocationManager = CLLocationManager()
    
    override init() {
        super.init()
        deviceLocationManager.desiredAccuracy = kCLLocationAccuracyBest
        deviceLocationManager.distanceFilter = kCLDistanceFilterNone
        deviceLocationManager.requestWhenInUseAuthorization()
        deviceLocationManager.startUpdatingLocation()
        deviceLocationManager.delegate = self
    }
}

extension DeviceLocationManager : CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.last else {return}
        self.location = location
        self.region = MKCoordinateRegion(center: location.coordinate, latitudinalMeters: 5000, longitudinalMeters: 5000)
    }
}
