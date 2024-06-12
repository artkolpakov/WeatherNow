//
//  Utils.swift
//  WeatherNow
//
//  Created by Artem Kolpakov on 6/5/24.
//

import Foundation

// A helper function that converts OpenWeatherMap icon codes to SF Symbols.
func mapIcon(_ icon: String) -> String {
    switch icon {
    case "01d": return "sun.max.fill"
    case "01n": return "moon.stars.fill"
    case "02d": return "cloud.sun.fill"
    case "02n": return "cloud.moon.fill"
    case "03d", "03n": return "cloud.fill"
    case "04d", "04n": return "smoke.fill"
    case "09d", "09n": return "cloud.drizzle.fill"
    case "10d": return "cloud.sun.rain.fill"
    case "10n": return "cloud.moon.rain.fill"
    case "11d", "11n": return "cloud.bolt.fill"
    case "13d", "13n": return "cloud.snow.fill"
    case "50d", "50n": return "cloud.fog.fill"
    default: return "cloud.fill" // Default icon
    }
}

func isToday(_ weekDay: String) -> Bool {
    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = "EEEE"
    let today = dateFormatter.string(from: Date())
    return weekDay == today
}

func precipitationProbability(from pop: Double) -> String {
    guard pop >= 0 && pop <= 1.0 else {
        return "Invalid POP value" // Handle invalid POP values
    }
    
    let popPercentage = Int(pop * 100)
    
    switch popPercentage {
    case 0..<15:
        return "."
    case 15..<30:
        return "with a low chance of precipitation."
    case 30..<70:
        return "with a medium chance of precipitation."
    default:
        return "with a high chance of precipitation."
    }
}
