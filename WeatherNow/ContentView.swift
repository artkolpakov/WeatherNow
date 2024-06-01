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
        NavigationStack {
            ZStack {
                BackgroundView(isNightTime: isNightTime)
                
                VStack {
                    Button(action: {
                        isEditingLocation.toggle()
                    }) {
                        HStack(spacing: 5) {
                            LocationView(cityName: forecastLocation.address.isEmpty ? "Corvallis, OR" : forecastLocation.address)
                            Image(systemName: "pencil")
                                .foregroundColor(.white)
                                .font(.system(size: 20))
                        }
                    }
                    .padding(.vertical, 25)
                    .padding(.top, 20)
                    
                    CurrentWeatherDataView(image: (name: "cloud.sun.fill", width: 200, height: 150), temperature: 76)
                    
                    HStack(spacing: 20) {
                        WeatherDayView(dayOfWeek: "TUE", image: (name: "cloud.sun.rain.fill", width: 40, height: 40), temperature: 74)
                        WeatherDayView(dayOfWeek: "WED", image: (name: "cloud.moon.fill", width: 40, height: 40), temperature: 67)
                        WeatherDayView(dayOfWeek: "THU", image: (name: "snow", width: 40, height: 40), temperature: 46)
                        WeatherDayView(dayOfWeek: "FRI", image: (name: "cloud.bolt.fill", width: 40, height: 40), temperature: 43)
                        WeatherDayView(dayOfWeek: "FRI", image: (name: "sun.max.fill", width: 40, height: 40), temperature: 88)
                    }
                    Spacer()
                    
                    Button {
                        isNightTime.toggle()
                    } label: {
                        Text("Change Location")
                            .foregroundColor(Color.blue)
                            .frame(width: 200, height: 60)
                            .background(Color.white)
                            .font(.system(size: 20, weight: .bold, design: .default))
                            .cornerRadius(15)
                    }
                    
                    Spacer()
                }
            }.onAppear {
                fetchForecast()
            }
            .onChange(of: forecastLocation) { oldForecastLocation, newForecastLocation in
                fetchForecast()
            }
        }.fullScreenCover(isPresented: $isEditingLocation) {
            ForecastLocationSearchView(forecastLocation: $forecastLocation, isEditingLocation: $isEditingLocation)
        }
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

struct BackgroundView: View {
    var isNightTime: Bool
    
    var body: some View {
        LinearGradient(gradient: Gradient(colors: [isNightTime ? Color.black : Color.blue, isNightTime ? Color.gray : Color.lightBlue]),
                       startPoint: .topLeading,
                       endPoint: .bottomTrailing)
        .ignoresSafeArea()
    }
}

struct LocationView: View {
    var cityName: String
    
    var body: some View {
        Text(cityName)
            .font(.system(size: 32, weight: .semibold, design: .rounded))
            .foregroundColor(.white)
            .padding(.vertical, 16)
            .padding(.horizontal, 4)
    }
}

struct CurrentWeatherDataView: View {
    var image: (name: String, width: Int, height: Int)
    var temperature: Int
    
    var body: some View {
        VStack(spacing: 8) {
            Image(systemName: image.name)
                .symbolRenderingMode(.multicolor)
                .resizable()
                .frame(width: 200, height: 150)
            
            Text("\(temperature)°")
                .font(.system(size: 68, weight: .bold, design: .rounded))
                .foregroundStyle(Color.white)
                .padding(.bottom, 40)
        }
    }
}

struct WeatherDayView: View {
    var dayOfWeek: String
    var image: (name: String, width: Int, height: Int)
    var temperature: Int
    
    var body: some View {
        VStack {
            Text(dayOfWeek)
                .font(.system(size: 18, weight: .bold, design: .rounded))
                .foregroundColor(Color.white)
            Image(systemName: image.name)
                .renderingMode(.original)
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: CGFloat(image.width), height: CGFloat(image.height))
            Text("\(temperature)°")
                .font(.system(size: 26, weight: .medium, design: .rounded))
                .foregroundColor(Color.white)
        }
    }
}
