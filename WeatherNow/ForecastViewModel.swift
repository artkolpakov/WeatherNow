//
//  ForecastViewModel.swift
//  WeatherNow
//
//  Created by Artem Kolpakov on 5/3/24.
//

import SwiftUI

@MainActor final class ForecastViewModel: ObservableObject {
    @Published var forecast: FiveDayForecast?
    @Published var isLoading = false
    
    func getForecastData(latitude: Double, longitude: Double) {
        Task {
            do {
                forecast = try await APIService.shared.getForecast(latitude: latitude, longitude: longitude)
                print("forecast fetch for \(forecast!.city.name) succeeded, forcast 5 day data:")
                for (index, day) in (forecast?.list ?? []).enumerated() {
                    print("forecast[\(index)]:", day)
                }
                
                isLoading = false
            } catch {
                // TODO: set an alert that fetching process failed
                if let fetchError = error as? APIError {
                    print(fetchError)
                } else {
                    print("Another error type")
                }
                isLoading = false
            }
        }
    }
}
