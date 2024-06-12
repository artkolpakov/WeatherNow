//
//  LocationStorage.swift
//  WeatherNow
//
//  Created by Artem Kolpakov on 6/12/24.
//

import SwiftUI

class LocationStorage {
    @AppStorage("lastLatitude") private var lastLatitude: Double?
    @AppStorage("lastLongitude") private var lastLongitude: Double?
    
    func saveLocation(latitude: Double, longitude: Double) {
        lastLatitude = latitude
        lastLongitude = longitude
    }
    
    func getLastLocation() -> (latitude: Double?, longitude: Double?) {
        return (lastLatitude, lastLongitude)
    }
}
