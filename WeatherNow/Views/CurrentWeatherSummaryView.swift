//
//  CurrentWeatherSummaryView.swift
//  WeatherNow
//
//  Created by Artem Kolpakov on 6/5/24.
//

import SwiftUI

struct CurrentWeatherSummaryView: View {
    var cityName: String
    var currentTemperature: Int
    var weatherDescription: String
    var highTemperature: Int
    var lowTemperature: Int
    
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
            
            Text(weatherDescription)
                .font(.system(size: 18))
                .fontWeight(.medium)
                .shadow(radius: 2.0)
                .foregroundColor(.white)
                .shadow(radius: 2.0)
            
            Text("H:\(highTemperature)° L:\(lowTemperature)°")
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
            return 70
        case 3: // Three digits (including negative sign)
            return 90
        default:
            return 72
        }
    }
}
