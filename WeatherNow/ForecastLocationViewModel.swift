//
//  ForecastLocationViewModel.swift
//  WeatherNow
//
//  Created by Artem Kolpakov on 5/27/24.
//

import Foundation
import MapKit

@MainActor
class ForecastLocationViewModel: ObservableObject {
    @Published var forecastLocations: [ForecastLocation] = []
    
    func search(text: String, region: MKCoordinateRegion) {
        let searchRequest = MKLocalSearch.Request()
        searchRequest.naturalLanguageQuery = text
        searchRequest.region = region
        let search = MKLocalSearch(request: searchRequest)
        
        search.start { response, error in
            guard let response = response else {
                print("Error when searching: \(error?.localizedDescription ?? "Unknown Error")")
                return
            }
            
            self.forecastLocations = response.mapItems.map(ForecastLocation.init)
        }
    }
}
