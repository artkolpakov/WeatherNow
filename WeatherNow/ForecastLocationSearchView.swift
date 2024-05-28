//
//  LocationLookupView.swift
//  WeatherNow
//
//  Created by Artem Kolpakov on 5/26/24.
//

import SwiftUI

struct ForecastLocationSearchView: View {
    @EnvironmentObject var locationManager: DeviceLocationManager
    @State var forecastLocationViewModel = ForecastLocationViewModel()
    
    @State private var searchText = ""
    @Environment(\.dismiss) private var dismiss
    
    @Binding var forecastLocation: ForecastLocation
    @Binding var isEditingLocation: Bool
    
    var body: some View {
        NavigationStack {
            List(forecastLocationViewModel.forecastLocations) { location in
                VStack{
                    Text(location.name)
                        .font(.title2)
                    Text(location.address)
                        .font(.callout)
                }.onTapGesture {
                    forecastLocation = location
                    isEditingLocation.toggle()
                    dismiss()
                }
            }
            .listStyle(.plain)
            .searchable(text: $searchText)
            .onChange(of: searchText) { oldValue, newValue in
              if !newValue.isEmpty {
                forecastLocationViewModel.search(text: newValue, region: locationManager.region)
              }
            }
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Dismiss") {
                        isEditingLocation.toggle()
                        dismiss()
                    }
                }
            }
        }
    }
}
