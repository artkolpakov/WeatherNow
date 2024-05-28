//
//  WeatherNowApp.swift
//  WeatherNow
//
//  Created by Artem Kolpakov on 4/6/24.
//

import SwiftUI

@main
struct WeatherNowApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(DeviceLocationManager())
        }
    }
}
