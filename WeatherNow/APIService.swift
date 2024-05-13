//
//  APIService.swift
//  WeatherNow
//
//  Created by Artem Kolpakov on 5/2/24.
//

import Foundation

final class APIService {
    static let shared = APIService()    // Create a Singleton Class
    
    static let baseURL = "https://api.openweathermap.org/data/2.5/"
    private let forecastURL = "https://api.openweathermap.org/data/2.5/forecast?lat=44.564568&lon=-123.262047&appid=YOUR_API_KEY"
    
    private init() {}
    
    func getForecast() async throws -> FiveDayForecast {
        guard let url = URL(string: forecastURL) else {
            throw APIError.invalidURL
        }
        
        let (data, _) = try await URLSession.shared.data(from: url)
        
        do {
            let decoder = JSONDecoder()
            decoder.dateDecodingStrategy = .secondsSince1970
            
            let decodedResponce = try decoder.decode(FiveDayForecast.self, from: data)
            return decodedResponce
        } catch {
            print(error)
            throw APIError.invalidData
        }
    }
}
