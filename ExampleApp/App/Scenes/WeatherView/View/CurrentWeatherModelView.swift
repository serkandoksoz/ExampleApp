//
//  CurrentWeatherModelView.swift
//  ExampleApp
//
//  Created by Serkan Doksöz on 10.12.2025.
//
import SwiftUI
import Foundation
import CoreLocation

struct CurrentWeatherModelView: View {
    let weather: CurrentWeatherModel
    let cityName: String
    
    var body: some View {
        VStack(spacing: 15) {
            Text(cityName)
                .font(.title)
                .fontWeight(.medium)
                .foregroundColor(.white)
            
            HStack(spacing: 20) {
                Image(systemName: WeatherIconHelper.icon(for: weather.weatherCode, isDay: weather.isDay == 1))
                    .font(.system(size: 80))
                    .foregroundColor(.white)
                    .symbolRenderingMode(.hierarchical)
                
                VStack(alignment: .leading, spacing: 5) {
                    Text("\(Int(weather.temperature2m))°")
                        .font(.system(size: 72, weight: .thin))
                        .foregroundColor(.white)
                    
                    Text(WeatherIconHelper.description(for: weather.weatherCode))
                        .font(.title3)
                        .foregroundColor(.white.opacity(0.8))
                }
            }
            
            Text("Hissedilen \(Int(weather.apparentTemperature))°")
                .font(.subheadline)
                .foregroundColor(.white.opacity(0.8))
        }
        .padding(.vertical)
    }
}
