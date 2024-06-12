//
//  UpcomingDailyForecastView.swift
//  WeatherNow
//
//  Created by Artem Kolpakov on 6/5/24.
//

import SwiftUI

struct UpcomingDailyForecastView: View {
    var dailyData: [(id: UUID, weekDay: String, icon: String, minTemp: Int, maxTemp: Int)]
    
    var body: some View {
        VStack(alignment: .leading) {
            (Text(Image(systemName: "calendar")) + Text("  5-Day Forecast".uppercased()))
                .font(.system(size: 12))
                .fontWeight(.medium)
                .foregroundColor(.white.opacity(0.6))
            
            Divider()
                .overlay(Color.white)
            
            ForEach(dailyData, id: \.id) { day in
                HStack {
                    Text(isToday(day.weekDay) ? "Today" : day.weekDay)
                        .font(.system(size: 18))
                        .fontWeight(.semibold)
                        .foregroundColor(.white)
                    
                    Spacer()
                    
                    Image(systemName: mapIcon(day.icon))
                        .symbolRenderingMode(.multicolor)
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 23, height: 25)
                    
                    Spacer()
                        .frame(maxWidth: 70)
                    
                    (Text("\(day.minTemp)°") + Text(Image(systemName: "thermometer.low")).foregroundColor(.blue.opacity(0.8)))
                        .foregroundColor(.white)
                        .font(.system(size: 19))
                    
                    Spacer()
                        .frame(maxWidth: 15.0)
                    
                    (Text("\(day.maxTemp)°") + Text(Image(systemName: "thermometer.high")).foregroundColor(.red.opacity(0.8)))
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
