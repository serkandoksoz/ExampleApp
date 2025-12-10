//
//  HourlyForecastModelView.swift
//  ExampleApp
//
//  Created by Serkan Doksöz on 10.12.2025.
//
import SwiftUI
import Foundation
import CoreLocation

struct HourlyForecastModelView: View {
    let forecasts: [HourlyForecastModel]
    
    var body: some View {
        VStack(alignment: .leading, spacing: 15) {
            Text("Saatlik Tahmin")
                .font(.headline)
                .foregroundColor(.white)
                .padding(.horizontal)
            
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 15) {
                    ForEach(forecasts.prefix(12)) { forecast in
                        VStack(spacing: 8) {
                            Text(forecast.time)
                                .font(.caption)
                                .foregroundColor(.white.opacity(0.8))
                            
                            Image(systemName: WeatherIconHelper.icon(for: forecast.weatherCode))
                                .font(.title2)
                                .foregroundColor(.white)
                                .symbolRenderingMode(.hierarchical)
                            
                            Text("\(Int(forecast.temperature))°")
                                .font(.subheadline)
                                .fontWeight(.medium)
                                .foregroundColor(.white)
                            
                            if forecast.precipitation > 0 {
                                Text("\(Int(forecast.precipitation))mm")
                                    .font(.caption2)
                                    .foregroundColor(.blue.opacity(0.8))
                            }
                        }
                        .padding(.vertical, 12)
                        .padding(.horizontal, 8)
                        .background(Color.white.opacity(0.2))
                        .cornerRadius(15)
                    }
                }
                .padding(.horizontal)
            }
        }
    }
}
