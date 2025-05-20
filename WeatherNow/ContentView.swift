//
//  ContentView.swift
//  WeatherNow
//
//  Created by Artem Kolpakov on 4/6/24.
//

import SwiftUI
import MapKit

struct ContentView: View {
    @Environment(\.colorScheme) var colorScheme
    @State private var isNightTime = false
    
    @State private var forecastLocation = ForecastLocation(mapItem: MKMapItem())
    @State private var isMetric = true
    @State private var isEditingLocation = false
    @EnvironmentObject var deviceLocationManager: DeviceLocationManager
    @StateObject var forecastViewModel = ForecastViewModel()
    private var locationStorage = LocationStorage()
    
    var body: some View {
        ScrollView(.vertical, showsIndicators: false) {
            VStack {
                HStack {
                    Text("F°")
                        .foregroundColor(.white)
                    Toggle("", isOn: $isMetric)
                        .labelsHidden()
                        .toggleStyle(SwitchToggleStyle(tint: .darkBlue))
                    Text("C°")
                        .foregroundColor(.white)
                }
                .padding(.top, 55)
                .padding(.bottom, 5)
                
                if forecastViewModel.isLoading {
                    HStack {
                        ProgressView()
                            .progressViewStyle(CircularProgressViewStyle(tint: .darkBlue))
                            .scaleEffect(3)
                    }
                    .padding(.top, 225)
                    .frame(maxWidth: .infinity)
                }
                
                if forecastViewModel.isErrorState {
                    HStack {
                        Text("Error fetching forecast 😦")
                            .font(.system(size: 20))
                            .foregroundColor(.white)
                            .shadow(radius: 2.0)
                            .multilineTextAlignment(.center)
                    }
                    .padding(.top, 225)
                    .frame(maxWidth: .infinity)
                    
                    HStack {
                        Text("Please try again later!")
                            .font(.system(size: 18))
                            .foregroundColor(.white)
                            .shadow(radius: 2.0)
                            .multilineTextAlignment(.center)
                    }
                    .padding(.top, 5)
                    .frame(maxWidth: .infinity)
                }
                
                if let forecast = forecastViewModel.forecast {
                    CurrentWeatherSummaryView(
                        cityName: forecast.city.name,
                        currentTemperature: Int(forecast.list[0].main.temp),
                        weatherDescription: forecast.list[0].weather[0].description,
                        highTemperature: Int(forecast.list[0].main.temp_max),
                        lowTemperature: Int(forecast.list[0].main.temp_min),
                        isEditingLocation: $isEditingLocation
                    )
                    .padding(.top, 0)
                    .padding(.bottom, 30)
                    
                    
                    CurrentWeatherHourlyDataView(
                        description: "Expect \(forecast.list[0].weather[0].description) conditions within the next few hours. Wind gusts are up to \(forecast.list[0].wind.speed) \(isMetric ? "mps": "mph")\(precipitationProbability(from: forecast.list[0].pop))",
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
                isNightTime = isNightTimeNow()
                fetchForecast()
            }
            .onChange(of: forecastLocation) { oldForecastLocation, newForecastLocation in
                saveLocation()
                fetchForecast()
            }
            .onChange(of: isMetric) { oldIsMetric, newIsMetric in
                fetchForecast()
            }
        }
        .background(BackgroundStyle)
        .fullScreenCover(isPresented: $isEditingLocation) {
            ForecastLocationSearchView(forecastLocation: $forecastLocation, isEditingLocation: $isEditingLocation)
        }
    }
    
    var BackgroundStyle: some ShapeStyle {
        LinearGradient(
            gradient: Gradient(colors: isNightTime
                ? [
                    Color(red: 0.2, green: 0.25, blue: 0.3).opacity(0.85),  // Lighter teal-ish blue
                    Color(red: 0.3, green: 0.3, blue: 0.35).opacity(0.7),   // Light gray-blue
                    Color(red: 0.45, green: 0.35, blue: 0.2).opacity(0.55), // Muted light orange-brown
                    Color(red: 0.3, green: 0.3, blue: 0.3).opacity(0.8)     // Light gray
                ]
                :   [Color.blue, Color.lightBlue]),
            startPoint: .top,
            endPoint: .bottom
        )
    }
    
    private func fetchForecast() {
        let (latitude, longitude) = determineLocation()
        let units = isMetric ? "metric" : "imperial"
        forecastViewModel.getForecastData(latitude: latitude, longitude: longitude, units: units)
    }
    
    private func determineLocation() -> (Double, Double) {
      let lastLocation = locationStorage.getLastLocation()
      if let latitude = lastLocation.latitude, let longitude = lastLocation.longitude {
        return (latitude, longitude)
      } else {
        if forecastLocation.address.isEmpty {
          return (deviceLocationManager.location?.coordinate.latitude ?? 44.564568,
                  deviceLocationManager.location?.coordinate.longitude ?? -123.262047)
        } else {
          return (forecastLocation.latitude, forecastLocation.longitude)
        }
      }
    }
    
    private func saveLocation() {
        locationStorage.saveLocation(latitude: forecastLocation.latitude, longitude: forecastLocation.longitude)
        print("Stored latitude: \(forecastLocation.latitude) and longitude: \(forecastLocation.longitude) locally.")
    }
}
