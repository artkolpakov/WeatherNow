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
                CurrentWeatherSummaryView(cityName: forecastLocation.address.isEmpty ? "Corvallis, OR" : forecastLocation.address, currentTemperature: 55, isEditingLocation: $isEditingLocation)
                    .padding(.top, 55)
                    .padding(.bottom, 35)
                
                CurrentWeatherHourlyDataView(image: (name: "cloud.sun.fill", width: 200, height: 150), temperature: 76)
                    .padding(.bottom, 10)
                
                UpcomingDailyForecastView()
                
                Spacer()
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

struct CurrentWeatherSummaryView: View {
    var cityName: String
    var currentTemperature: Int
    
    @Binding var isEditingLocation: Bool
    
    var body: some View {
        VStack {
            Button(action: {
                isEditingLocation.toggle()
            }) {
                HStack(spacing: 5) {
                    Text(cityName)
                        .font(.system(size: 32))
                        .foregroundColor(.white)
                        .shadow(radius: 2.0)
                    
                    Image(systemName: "pencil")
                        .foregroundColor(.white)
                        .font(.system(size: 20))
                }
            }
            
            ZStack {
                Text("\(currentTemperature)")
                    .font(.system(size: 100))
                    .fontWeight(.thin)
                    .foregroundColor(.white)
                    .shadow(radius: 2.0)
                
                Text("°")
                    .font(.system(size: 90))
                    .fontWeight(.thin)
                    .foregroundColor(.white)
                    .shadow(radius: 2.0)
                    .offset(x: degreeSymbolOffsetX(for: currentTemperature), y: -4)
            }
            
            Text("Mostly Sunny")
                .font(.system(size: 18))
                .fontWeight(.medium)
                .shadow(radius: 2.0)
                .foregroundColor(.white)
                .shadow(radius: 2.0)
            
            Text("H:72° L:12°")
                .font(.system(size: 18))
                .fontWeight(.medium)
                .foregroundColor(.white)
                .shadow(radius: 2.0)
        }
    }
    
    // Function to calculate the offset for the degree symbol based on the length of the temperature string
    func degreeSymbolOffsetX(for temperature: Int) -> CGFloat {
        let temperatureString = String(temperature)
        let digitCount = temperatureString.count
        
        switch digitCount {
        case 1: // One digit
            return 40
        case 2: // Two digits
            return 72
        case 3: // Three digits (including negative sign)
            return 90
        default:
            return 72
        }
    }
}


struct CurrentWeatherHourlyDataView: View {
    var image: (name: String, width: Int, height: Int)
    var temperature: Int
    
    var body: some View {
        VStack(alignment: .leading) {
            Text("description description description description description description ")
                .font(.system(size: 14))
                .fontWeight(.medium)
                .foregroundColor(.white)
                .shadow(radius: 2.0)
                .padding(.bottom, 6)
            
            Divider()
                .overlay(Color.white)
                .padding(.bottom, 10)
            
            ScrollView(.horizontal) {
                HStack {
                    ForEach(1..<4) { _ in
                        VStack {
                            Text("13:00")
                                .font(.system(size: 14))
                                .fontWeight(.semibold)
                                .foregroundColor(.white)
                            
                            Image(systemName: image.name)
                                .symbolRenderingMode(.multicolor)
                                .resizable()
                                .frame(width: 25, height: 20)
                                .padding(.vertical, 4)
                            
                            Text("\(temperature)°")
                                .font(.system(size: 20))
                                .fontWeight(.medium)
                                .foregroundColor(.white)
                        }
                        .padding(.trailing, 14)
                    }
                }
            }.scrollIndicators(.never)
        }
        .padding(14)
        .background(
            RoundedRectangle(cornerRadius: 16.0)
                .fill(Color.darkBlue.opacity(0.38))
        )
    }
}

struct UpcomingDailyForecastView: View {
    var body: some View {
        VStack(alignment: .leading) {
            (Text(Image(systemName: "calendar")) + Text("  5-Day Forecast".uppercased()))
                .font(.system(size: 12))
                .fontWeight(.medium)
                .foregroundColor(.white.opacity(0.6))
            
            Divider()
                .overlay(Color.white)
            
            ForEach(0..<5) { _ in
                HStack {
                    Text("Today")
                        .font(.system(size: 18))
                        .fontWeight(.semibold)
                        .foregroundColor(.white)
                    
                    Spacer()
                    
                    Image(systemName: "sun.max.fill")
                        .foregroundColor(.yellow)
                        .font(.system(size: 20))
                    
                    Spacer()
                        .frame(maxWidth: 110)
                    
                    (Text("52°") + Text(Image(systemName: "thermometer.low")).foregroundColor(.blue.opacity(0.8)))
                        .foregroundColor(.white)
                        .font(.system(size: 19))
                    
                    Spacer()
                        .frame(maxWidth: 15.0)
                    
                    (Text("72°") + Text(Image(systemName: "thermometer.high")).foregroundColor(.red.opacity(0.8)))
                        .foregroundColor(.white)
                        .font(.system(size: 19))
                }
                Divider()
                    .overlay(Color.white)
            }
        }
        .padding(10)
        .background(
            RoundedRectangle(cornerRadius: 16.0)
                .fill(Color.darkBlue.opacity(0.38))
        )
    }
}
