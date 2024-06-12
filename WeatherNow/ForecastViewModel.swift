import SwiftUI

@MainActor final class ForecastViewModel: ObservableObject {
    @Published var forecast: FiveDayForecast?
    @Published var dailyForecasts: [String: [FiveDayForecast.Forecast]] = [:]
    @Published var isLoading = false
    @Published var upcomingDailyData: [(id: UUID, weekDay: String, icon: String, minTemp: Int, maxTemp: Int)] = []
    @Published var units: String = "metric" // Default units
    
    func getForecastData(latitude: Double, longitude: Double, units: String) {
        Task {
            do {
                forecast = try await APIService.shared.getForecast(latitude: latitude, longitude: longitude, units: units)
                print("forecast fetch for \(forecast!.city.name) succeeded, forecast 5 day data:")
                processForecastData()
                prepareUpcomingDailyData()
                
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

    private func processForecastData() {
        guard let forecastList = forecast?.list else { return }

        // Create a DateFormatter to format the date as a day of the week
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "EEEE"

        // Clear the previous data
        dailyForecasts.removeAll()

        // Iterate over the forecasts and group them by day of the week
        for forecast in forecastList {
            let dayOfWeek = dateFormatter.string(from: forecast.dt)

            if dailyForecasts[dayOfWeek] != nil {
                dailyForecasts[dayOfWeek]?.append(forecast)
            } else {
                dailyForecasts[dayOfWeek] = [forecast]
            }
        }

        // Print out the daily forecasts for debugging
        for (day, forecasts) in dailyForecasts {
            print("\(day): \(forecasts.count) forecasts")
            for forecast in forecasts {
                print(" - \(forecast.dt): \(forecast.main.temp)°C")
            }
        }
    }

    private func prepareUpcomingDailyData() {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "EEEE"

        var dailyData: [(id: UUID, weekDay: String, icon: String, minTemp: Int, maxTemp: Int)] = []

        // Get the current day of the week
        let currentWeekDay = dateFormatter.string(from: Date())

        // Create an ordered array of days starting from today
        let allDaysOfWeek = ["Sunday", "Monday", "Tuesday", "Wednesday", "Thursday", "Friday", "Saturday"]
        guard let startIndex = allDaysOfWeek.firstIndex(of: currentWeekDay) else { return }
        let sortedDaysOfWeek = Array(allDaysOfWeek[startIndex...]) + Array(allDaysOfWeek[..<startIndex])

        for day in sortedDaysOfWeek {
            if let forecasts = dailyForecasts[day] {
                let minTemp = forecasts.map { $0.main.temp_min }.min() ?? 0
                let maxTemp = forecasts.map { $0.main.temp_max }.max() ?? 0

                // Find the forecast with the maximum temp_max
                if let warmestForecast = forecasts.max(by: { $0.main.temp_max < $1.main.temp_max }) {
                    let icon = warmestForecast.weather.first?.icon ?? "questionmark"
                    dailyData.append((id: UUID(), weekDay: day, icon: icon, minTemp: Int(minTemp), maxTemp: Int(maxTemp)))
                }
            }
        }

        upcomingDailyData = dailyData
    }
}
