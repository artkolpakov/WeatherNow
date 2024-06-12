//
//  ContentView.swift
//  WeatherNow
//
//  Created by Artem Kolpakov on 4/6/24.
//

import SwiftUI
import MapKit

struct ContentView: View {
    @State private var isNightTime = false
    @State private var forecastLocation = ForecastLocation(mapItem: MKMapItem())
    
    @State private var isEditingLocation = false
    @EnvironmentObject var deviceLocationManager: DeviceLocationManager
    @StateObject var forecastViewModel = ForecastViewModel()
    
    var body: some View {
        ScrollView(.vertical, showsIndicators: false) {
            VStack {
                if let forecast = forecastViewModel.forecast {
                    CurrentWeatherSummaryView(
                        cityName: forecast.city.name,
                        currentTemperature: Int(forecast.list[0].main.temp),
                        weatherDescription: forecast.list[0].weather[0].description,
                        highTemperature: Int(forecast.list[0].main.temp_max),
                        lowTemperature: Int(forecast.list[0].main.temp_min),
                        isEditingLocation: $isEditingLocation
                    )
                    .padding(.top, 55)
                    .padding(.bottom, 30)
                    
                    
                    CurrentWeatherHourlyDataView(
                        description: "Expect \(forecast.list[0].weather[0].description) conditions within the next few hours. Wind gusts are up to \(forecast.list[0].wind.speed) m/s \(precipitationProbability(from: forecast.list[0].pop))",
                        hourlyData: forecast.list.prefix(39).map { forecast in
                            let dateFormatter = DateFormatter()
                            dateFormatter.dateFormat = "HH:mm"
                            let time = dateFormatter.string(from: forecast.dt)
                            return (id: UUID(), time: time, icon: forecast.weather[0].icon, temperature: Int(forecast.main.temp))
                        }
                    )
                    .padding(.bottom, 10)
                    
                    UpcomingDailyForecastView(dailyData: forecastViewModel.upcomingDailyData)
                    
                    Spacer()
                }
            }
            .padding(.horizontal)
            .onAppear {
                fetchForecast()
            }
            .onChange(of: forecastLocation) { oldForecastLocation, newForecastLocation in
                fetchForecast()
            }
        }
        .background(BackgroundStyle)
        .fullScreenCover(isPresented: $isEditingLocation) {
            ForecastLocationSearchView(forecastLocation: $forecastLocation, isEditingLocation: $isEditingLocation)
        }
    }
    
    var BackgroundStyle: some ShapeStyle {
        return LinearGradient(
            gradient: Gradient(colors: [isNightTime ? Color.black : Color.blue, isNightTime ? Color.gray : Color.lightBlue]),
            startPoint: .topLeading,
            endPoint: .bottomTrailing
        )
    }
    
    private func fetchForecast() {
        let latitude: Double
        let longitude: Double
        
        if forecastLocation.address.isEmpty {
            latitude = deviceLocationManager.location?.coordinate.latitude ?? 44.564568
            longitude = deviceLocationManager.location?.coordinate.longitude ?? -123.262047
        } else {
            latitude = forecastLocation.latitude
            longitude = forecastLocation.longitude
        }
        
        forecastViewModel.getForecastData(latitude: latitude, longitude: longitude)
    }
}
