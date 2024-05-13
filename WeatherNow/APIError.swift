//
//  APIError.swift
//  WeatherNow
//
//  Created by Artem Kolpakov on 5/2/24.
//

import Foundation

enum APIError: Error {
    case invalidURL
    case invalidResponse
    case invalidData
    case unableToComplete
}
