//
//  SwiftUIView.swift
//  WeatherNow
//
//  Created by Artem Kolpakov on 6/5/24.
//

import SwiftUI

struct CurrentWeatherHourlyDataView: View {
    var description: String
    var hourlyData: [(id: UUID, time: String, icon: String, temperature: Int)]
    
    var body: some View {
        VStack(alignment: .leading) {
            Text(description)
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
                    ForEach(hourlyData, id: \.id) { threeHourStep in
                        VStack {
                            Text(threeHourStep.time)
                                .font(.system(size: 14))
                                .fontWeight(.semibold)
                                .foregroundColor(.white)

                            Image(systemName: mapIcon(threeHourStep.icon))
                                .renderingMode(.original)
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .frame(width: 25, height: 25)
                                .padding(.vertical, 4)

                            Text("\(threeHourStep.temperature)°")
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
