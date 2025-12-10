//
//  DailyForecastModelView.swift
//  ExampleApp
//
//  Created by Serkan Doksöz on 10.12.2025.
//
import SwiftUI
import Foundation
import CoreLocation

struct DailyForecastModelView: View {
    let forecasts: [DailyForecastModel]
    
    var body: some View {
        VStack(alignment: .leading, spacing: 15) {
            Text("7 Günlük Tahmin")
                .font(.headline)
                .foregroundColor(.white)
                .padding(.horizontal)
            
            LazyVStack(spacing: 12) {
                ForEach(forecasts) { forecast in
                    HStack {
                        Text(forecast.date)
                            .font(.subheadline)
                            .fontWeight(.medium)
                            .foregroundColor(.white)
                            .frame(width: 50, alignment: .leading)
                        
                        Image(systemName: WeatherIconHelper.icon(for: forecast.weatherCode))
                            .font(.title3)
                            .foregroundColor(.white)
                            .symbolRenderingMode(.hierarchical)
                            .frame(width: 30)
                        
                        Spacer()
                        
                        if forecast.precipitation > 0 {
                            Text("\(Int(forecast.precipitation))mm")
                                .font(.caption)
                                .foregroundColor(.blue.opacity(0.8))
                                .frame(width: 35)
                        } else {
                            Spacer().frame(width: 35)
                        }
                        
                        HStack(spacing: 8) {
                            Text("\(Int(forecast.minTemp))°")
                                .foregroundColor(.white.opacity(0.6))
                            
                            Text("\(Int(forecast.maxTemp))°")
                                .fontWeight(.semibold)
                                .foregroundColor(.white)
                        }
                        .frame(width: 70, alignment: .trailing)
                    }
                    .padding(.horizontal)
                    .padding(.vertical, 8)
                    .background(Color.white.opacity(0.1))
                    .cornerRadius(12)
                }
            }
            .padding(.horizontal)
        }
    }
}
