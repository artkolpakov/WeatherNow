//
//  ContentView.swift
//  WeatherNow
//
//  Created by Artem Kolpakov on 4/6/24.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        ZStack {
            BackgroundView(topColor: Color.blue, bottomColor: Color.lightBlue)
                           
            VStack {
                LocationView(cityName: "Corvallis, OR")
                CurrentWeatherDataView(image: (name: "cloud.sun.fill", width: 200, height: 150), temperature: 76)
                
                HStack (spacing: 20){
                    WeatherDayView(dayOfWeek: "TUE", image: (name: "cloud.sun.rain.fill", width: 40, height: 40), temperature: 74)
                    WeatherDayView(dayOfWeek: "WED", image: (name: "cloud.moon.fill", width: 40, height: 40), temperature: 67)
                    WeatherDayView(dayOfWeek: "THU", image: (name: "snow", width: 40, height: 40), temperature: 46)
                    WeatherDayView(dayOfWeek: "FRI", image: (name: "cloud.bolt.fill", width: 40, height: 40), temperature: 43)
                    WeatherDayView(dayOfWeek: "FRI", image: (name: "sun.max.fill", width: 40, height: 40), temperature: 88)
                }
                Spacer()
                
                Button {
                    print("TODO: implement the button handler!")
                } label: {
                    Text("Change Location")
                        .foregroundColor(Color.blue) // Set text color to black
                        .frame(width: 200, height: 60)
                        .background(Color.white)
                        .font(.system(size: 20, weight: .bold, design: .default))
                        .cornerRadius(15)
                }
                
                Spacer()
            }
        }
    }
}

#Preview {
    ContentView()
}

struct BackgroundView: View {
    var topColor: Color
    var bottomColor: Color

    var body: some View {
        LinearGradient(gradient: Gradient(colors: [topColor, bottomColor]),
                       startPoint: .topLeading,
                       endPoint: .bottomTrailing)
            .edgesIgnoringSafeArea(.all)
    }
}

struct LocationView: View {
    var cityName: String
    
    var body: some View {
        Text(cityName)
        .font(.system(size: 32, weight: .medium, design: .rounded))
        .foregroundColor(.white)
        .padding(23)
    }
}

struct CurrentWeatherDataView: View {
    var image: (name: String, width: Int, height: Int)
    var temperature: Int
    
    var body: some View {
        VStack (spacing: 8){
            Image(systemName: image.name)
                .renderingMode(.original)
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
                .aspectRatio(contentMode: .fit) // Set aspect ratio
                .frame(width: CGFloat(image.width), height: CGFloat(image.height))
            Text("\(temperature)°")
                .font(.system(size: 26, weight: .medium, design: .rounded))
                .foregroundColor(Color.white)
        }
    }
}
