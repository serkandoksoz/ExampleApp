//
//  WeatherDetailsView.swift
//  ExampleApp
//
//  Created by Serkan Doksöz on 10.12.2025.
//
import SwiftUI
import Foundation
import CoreLocation

struct WeatherDetailsView: View {
    let weather: CurrentWeatherModel
    
    var body: some View {
        VStack(alignment: .leading, spacing: 15) {
            Text("Detaylar")
                .font(.headline)
                .foregroundColor(.white)
                .padding(.horizontal)
            
            LazyVGrid(columns: [
                GridItem(.flexible()),
                GridItem(.flexible())
            ], spacing: 15) {
                DetailCard(
                    icon: "humidity",
                    title: "Nem",
                    value: "\(weather.relativeHumidity2m)%"
                )
                
                DetailCard(
                    icon: "wind",
                    title: "Rüzgar",
                    value: "\(Int(weather.windSpeed10m)) km/h"
                )
                
                DetailCard(
                    icon: "cloud",
                    title: "Bulut",
                    value: "\(weather.cloudCover)%"
                )
                
                DetailCard(
                    icon: "drop",
                    title: "Yağış",
                    value: "\(weather.precipitation/*, specifier: "%.1f"*/) mm"
                )
            }
            .padding(.horizontal)
        }
    }
}
