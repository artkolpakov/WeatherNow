//
//  FiveDayForecast.swift
//  WeatherNow
//
//  Created by Artem Kolpakov on 5/2/24.
//

import Foundation

struct FiveDayForecast: Decodable {
    let cod: String
    let list: [Forecast]
    let city: City

    struct Forecast: Decodable {
        let dt: Date
        let main: Main
        let weather: [Weather]
        let wind: Wind
        let pop: Double

        struct Main: Decodable {
            let temp: Double
            let temp_min: Double
            let temp_max: Double
            let humidity: Int
        }

        struct Weather: Decodable {
            let id: Int
            let main: String
            let description: String
            let icon: String
            // var iconURL = "https://openweathermap.org/img/wn/\(icon).png"
        }

        struct Wind: Decodable {
            let speed: Double
            let deg: Int
        }
    }

    struct City: Decodable {
        let name: String
        let country: String
        let timezone: Int
        let sunrise: Int
        let sunset: Int
    }
}
